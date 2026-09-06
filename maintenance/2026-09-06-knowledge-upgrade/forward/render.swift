import AppKit
import CoreText

let output = URL(fileURLWithPath: CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "/private/tmp/design-forward-a076", isDirectory: true)
try FileManager.default.createDirectory(at: output, withIntermediateDirectories: true)
let fontName = "PingFangSC-Regular"
let title = "一次转动，路径不同"
let note = "几何示意，不代表实际测量。"
let text1 = "起点 A 与终点 B 以直线连接。"
let text2 = "起点 A 不变；终点 B 左移，路径出现转折。"
let bodyLines = [["起点 A 与终点 B ", "以直线连接。"], ["起点 A 不变；", "终点 B 左移，", "路径出现转折。"]]
precondition(bodyLines[0].joined() == text1)
precondition(bodyLines[1].joined() == text2)
func font(_ size: CGFloat) -> NSFont {
    guard let f = NSFont(name: fontName, size: size), f.fontName == fontName else { fatalError("Specified font unavailable") }
    return f
}
let ctFont = CTFontCreateWithName(fontName as CFString, 22, nil)
let allText = title + "路径示意" + note + text1 + text2 + "AB0102状态一状态二"
let chars = Array(allText.utf16)
var glyphs = Array(repeating: CGGlyph(0), count: chars.count)
precondition(CTFontGetGlyphsForCharacters(ctFont, chars, &glyphs, chars.count), "Missing required glyph")
let testLine = CTLineCreateWithAttributedString(NSAttributedString(string: allText, attributes: [.font: font(22)]))
var usedFonts = Set<String>()
for run in CTLineGetGlyphRuns(testLine) as! [CTRun] {
    let attributes = CTRunGetAttributes(run) as NSDictionary
    let f = attributes[kCTFontAttributeName] as! CTFont
    usedFonts.insert(CTFontCopyPostScriptName(f) as String)
}
precondition(usedFonts == [fontName], "Font fallback detected: \(usedFonts)")

func writePNG(_ bitmap: NSBitmapImageRep, _ name: String) throws {
    guard let data = bitmap.representation(using: .png, properties: [:]) else { fatalError("PNG encoding failed") }
    try data.write(to: output.appendingPathComponent(name))
}
func canvas(_ width: Int, _ height: Int, draw: () -> Void) -> NSBitmapImageRep {
    let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: width, pixelsHigh: height, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    let graphics = NSGraphicsContext(bitmapImageRep: bitmap)!
    let cg = graphics.cgContext
    cg.translateBy(x: 0, y: CGFloat(height))
    cg.scaleBy(x: 1, y: -1)
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(cgContext: cg, flipped: true)
    NSColor.white.setFill()
    NSRect(x: 0, y: 0, width: width, height: height).fill()
    draw()
    NSGraphicsContext.restoreGraphicsState()
    return bitmap
}
func text(_ string: String, x: CGFloat, y: CGFloat, size: CGFloat, width: CGFloat = 804, alignment: NSTextAlignment = .left) {
    let para = NSMutableParagraphStyle()
    para.alignment = alignment
    para.lineBreakMode = .byClipping
    NSAttributedString(string: string, attributes: [.font: font(size), .foregroundColor: NSColor.black, .paragraphStyle: para]).draw(in: NSRect(x: x, y: y, width: width, height: size * 1.6))
}
func line(_ points: [NSPoint], width: CGFloat) {
    let path = NSBezierPath()
    path.move(to: points[0])
    for p in points.dropFirst() { path.line(to: p) }
    path.lineWidth = width
    path.lineJoinStyle = .miter
    NSColor.black.setStroke()
    path.stroke()
}
func point(_ p: NSPoint, label: String) {
    NSColor.white.setFill()
    NSBezierPath(ovalIn: NSRect(x: p.x - 7, y: p.y - 7, width: 14, height: 14)).fill()
    NSColor.black.setFill()
    NSBezierPath(ovalIn: NSRect(x: p.x - 4, y: p.y - 4, width: 8, height: 8)).fill()
    text(label, x: p.x - 8, y: p.y - 43, size: 24, width: 32)
}
func render(_ state: Int, title: String) -> NSBitmapImageRep {
    return canvas(900, 560) {
        text(title, x: 48, y: 44, size: 34)
        line([NSPoint(x: 48, y: 116), NSPoint(x: 852, y: 116)], width: 1)
        // Content width 804 = diagram 536 + explanation 268.
        line([NSPoint(x: 584, y: 152), NSPoint(x: 584, y: 430)], width: 0.75)
        let a = NSPoint(x: 104, y: 396)
        let b = NSPoint(x: state == 0 ? 520 : 104, y: 184)
        let points = state == 0 ? [a, b] : [a, NSPoint(x: 504, y: 396), b]
        line(points, width: 1.5)
        point(a, label: "A")
        point(b, label: "B")
        for (i, content) in bodyLines[state].enumerated() {
            text(content, x: 620, y: 217 + CGFloat(i) * 35, size: 22, width: 232)
        }
        text(note, x: 48, y: 453, size: 15)
        line([NSPoint(x: 48, y: 491), NSPoint(x: 852, y: 491)], width: 1)
        text(state == 0 ? "01" : "02", x: 48, y: 509, size: 18, width: 60)
        text(state == 0 ? "状态一" : "状态二", x: 732, y: 509, size: 18, width: 120, alignment: .right)
    }
}
let first = render(0, title: title)
let second = render(1, title: title)
let single = render(0, title: "路径示意")
try writePNG(first, "state-01.png")
try writePNG(second, "state-02.png")
try writePNG(single, "single-path.png")
let overview = canvas(1864, 608) {
    for (i, name) in ["state-01.png", "state-02.png"].enumerated() {
        let image = NSImage(contentsOf: output.appendingPathComponent(name))!
        image.draw(in: NSRect(x: 24 + i * 916, y: 24, width: 900, height: 560), from: .zero, operation: .sourceOver, fraction: 1, respectFlipped: true, hints: [.interpolation: NSImageInterpolation.high])
    }
}
try writePNG(overview, "overview.png")
print("Rendered 3 pages at 900×560 and 2-state overview at 1864×608.")
print("Resolved PostScript font: \(font(22).fontName)")
print("CoreText glyph coverage: \(glyphs.count) UTF-16 units, no missing glyphs.")
print("CoreText shaped run fonts: \(usedFonts.sorted().joined(separator: ", "))")
print("Exact body text preserved by joined line checks.")
