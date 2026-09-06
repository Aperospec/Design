import AppKit

// This study's exact copy, colors, sizes and geometry stay in maintenance.
let out = URL(fileURLWithPath: CommandLine.arguments[1], isDirectory: true)
try FileManager.default.createDirectory(at: out, withIntermediateDirectories: true)
let ink = NSColor(calibratedRed: 0.10, green: 0.16, blue: 0.19, alpha: 1)
let paper = NSColor(calibratedRed: 0.97, green: 0.96, blue: 0.93, alpha: 1)
let accent = NSColor(calibratedRed: 0.67, green: 0.22, blue: 0.12, alpha: 1)
var textRuns: [[String:Any]] = []
var current = ""
func box(_ x:CGFloat,_ y:CGFloat,_ w:CGFloat,_ h:CGFloat,_ c:NSColor) {
    c.setFill(); NSBezierPath(rect:NSRect(x:x,y:y,width:w,height:h)).fill()
}
func text(_ s:String,_ x:CGFloat,_ y:CGFloat,_ w:CGFloat,_ size:CGFloat,_ c:NSColor) {
    let p=NSMutableParagraphStyle(); p.lineSpacing=5
    let f=NSFont(name:"PingFangSC-Semibold",size:size)!
    let a=NSAttributedString(string:s,attributes:[.font:f,.foregroundColor:c,.paragraphStyle:p])
    let b=a.boundingRect(with:NSSize(width:w,height:2000),options:[.usesLineFragmentOrigin,.usesFontLeading])
    a.draw(with:NSRect(x:x,y:y,width:w,height:ceil(b.height)+8),options:[.usesLineFragmentOrigin,.usesFontLeading])
    textRuns.append(["plate":current,"text":s,"x":x,"y":y,"width":w,"height":ceil(b.height),"size":size,"font":f.fontName])
}
func line(_ x:CGFloat,_ y:CGFloat,_ xx:CGFloat,_ yy:CGFloat,_ width:CGFloat,_ c:NSColor) {
    c.setStroke(); let p=NSBezierPath(); p.move(to:NSPoint(x:x,y:y));p.line(to:NSPoint(x:xx,y:yy));p.lineWidth=width;p.stroke()
}
func circle(_ x:CGFloat,_ y:CGFloat,_ r:CGFloat,_ c:NSColor) {
    c.setFill();NSBezierPath(ovalIn:NSRect(x:x-r,y:y-r,width:2*r,height:2*r)).fill()
}
func make(_ name:String,_ draw:()->Void) throws {
    current=name
    let rep=NSBitmapImageRep(bitmapDataPlanes:nil,pixelsWide:646,pixelsHigh:660,bitsPerSample:8,samplesPerPixel:4,hasAlpha:true,isPlanar:false,colorSpaceName:.deviceRGB,bytesPerRow:0,bitsPerPixel:0)!
    NSGraphicsContext.saveGraphicsState(); NSGraphicsContext.current=NSGraphicsContext(bitmapImageRep:rep)!
    let cg=NSGraphicsContext.current!.cgContext; cg.translateBy(x:0,y:660);cg.scaleBy(x:1,y:-1)
    NSGraphicsContext.current=NSGraphicsContext(cgContext:cg,flipped:true)
    box(0,0,646,660,ink);draw();NSGraphicsContext.restoreGraphicsState()
    try rep.representation(using:.png,properties:[:])!.write(to:out.appendingPathComponent(name+".png"))
}
// K is the previous integrated composition, rendered with identical coordinates.
try make("plate-k") {
    box(42,77,208,470,paper);box(402,77,202,470,paper)
    box(145,255,358,105,ink)
    text("连接需要",48,91,556,48,ink)
    text("跨过间隔",145,266,385,62,.white)
}
// M revises the bridge and landing while retaining copy, blocks and font sizes.
try make("plate-m") {
    box(42,77,208,470,paper);box(402,77,202,470,paper)
    box(163,255,320,105,accent)
    text("连接需要",48,91,556,48,ink)
    text("跨过间隔",183,266,385,62,.white)
}
// R is the previous separate-text-and-diagram composition, unchanged.
try make("plate-r") {
    text("连接需要\n跨过间隔",48,50,550,60,.white)
    box(48,385,185,165,paper);box(413,385,185,165,paper)
    line(180,406,463,406,10,accent)
    circle(180,406,14,.white);circle(463,406,14,.white)
}
try JSONSerialization.data(withJSONObject:textRuns,options:[.prettyPrinted,.sortedKeys]).write(to:out.appendingPathComponent("text-runs.json"))
print("Rendered three unannotated compositions.")
