import AppKit
import CoreText

let destination = URL(fileURLWithPath: CommandLine.arguments[0]).deletingLastPathComponent()
let filename = "entrance-sign.png"
let width = 800
let height = 800
let fontName = "PingFangSC-Regular"
let lines = ["展览入口", "请向右行"]
func font(_ size: CGFloat) -> NSFont {
    guard let result = NSFont(name: fontName, size: size), result.fontName == fontName else {
        fatalError("Required font unavailable")
    }
    return result
}
let ctFont = CTFontCreateWithName(fontName as CFString, 96, nil)
let chars = Array(lines.joined().utf16)
var glyphs = Array(repeating: CGGlyph(0), count: chars.count)
precondition(CTFontGetGlyphsForCharacters(ctFont, chars, &glyphs, chars.count), "Missing glyph")
let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: width, pixelsHigh: height, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
let graphics = NSGraphicsContext(bitmapImageRep: bitmap)!
let cg = graphics.cgContext
cg.translateBy(x: 0, y: CGFloat(height))
cg.scaleBy(x: 1, y: -1)
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(cgContext: cg, flipped: true)
NSColor.white.setFill()
NSRect(x: 0, y: 0, width: width, height: height).fill()
for (index, content) in lines.enumerated() {
    let size: CGFloat = index == 0 ? 96 : 72
    let y: CGFloat = index == 0 ? 82 : 214
    NSAttributedString(string: content, attributes: [.font: font(size), .foregroundColor: NSColor.black]).draw(in: NSRect(x: 88, y: y, width: 624, height: size * 1.5))
}
// One right-pointing arrow, wholly within the lower half.
let vertices: [NSPoint] = [
    NSPoint(x: 88, y: 536), NSPoint(x: 515, y: 536),
    NSPoint(x: 515, y: 432), NSPoint(x: 712, y: 572),
    NSPoint(x: 515, y: 712), NSPoint(x: 515, y: 608),
    NSPoint(x: 88, y: 608)
]
let arrow = NSBezierPath()
arrow.move(to: vertices[0])
for vertex in vertices.dropFirst() { arrow.line(to: vertex) }
arrow.close()
NSColor.black.setFill()
arrow.fill()
NSGraphicsContext.restoreGraphicsState()
let data = bitmap.representation(using: .png, properties: [:])!
try data.write(to: destination.appendingPathComponent(filename))
print("Created \(filename): 800 × 800 PNG; \(fontName); both exact text lines have glyph coverage.")
