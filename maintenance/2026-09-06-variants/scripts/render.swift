import AppKit

// Exact experiment values are maintenance inputs, never runtime Skill defaults.
let out=URL(fileURLWithPath:CommandLine.arguments[1],isDirectory:true)
try FileManager.default.createDirectory(at:out,withIntermediateDirectories:true)
let ink=NSColor(calibratedRed:0.10,green:0.16,blue:0.19,alpha:1)
let paper=NSColor(calibratedRed:0.97,green:0.96,blue:0.93,alpha:1)
let accent=NSColor(calibratedRed:0.67,green:0.22,blue:0.12,alpha:1)
var records:[[String:Any]]=[]
var current=""
var canvasWidth=646
var canvasHeight=660
var outputScale:CGFloat=1
var outputOffsetY:CGFloat=0
func box(_ x:CGFloat,_ y:CGFloat,_ w:CGFloat,_ h:CGFloat,_ c:NSColor) {
    c.setFill();NSBezierPath(rect:NSRect(x:x,y:y,width:w,height:h)).fill()
}
func text(_ s:String,_ x:CGFloat,_ y:CGFloat,_ w:CGFloat,_ size:CGFloat,_ c:NSColor) {
    let p=NSMutableParagraphStyle();p.lineSpacing=5
    let f=NSFont(name:"PingFangSC-Semibold",size:size)!
    let a=NSAttributedString(string:s,attributes:[.font:f,.foregroundColor:c,.paragraphStyle:p])
    let b=a.boundingRect(with:NSSize(width:w,height:2000),options:[.usesLineFragmentOrigin,.usesFontLeading])
    a.draw(with:NSRect(x:x,y:y,width:w,height:ceil(b.height)+8),options:[.usesLineFragmentOrigin,.usesFontLeading])
    records.append(["file":current,"text":s,"sourceX":x,"sourceY":y,"sourceWidth":w,"sourceHeight":ceil(b.height),"font":f.fontName,"sourceFontSize":size,"localToPixelScale":outputScale,"pixelOffsetY":outputOffsetY,"canvasWidth":canvasWidth,"canvasHeight":canvasHeight])
}
func line(_ x:CGFloat,_ y:CGFloat,_ xx:CGFloat,_ yy:CGFloat,_ width:CGFloat,_ c:NSColor) {
    c.setStroke();let p=NSBezierPath();p.move(to:NSPoint(x:x,y:y));p.line(to:NSPoint(x:xx,y:yy));p.lineWidth=width;p.stroke()
}
func circle(_ x:CGFloat,_ y:CGFloat,_ r:CGFloat,_ c:NSColor) {
    c.setFill();NSBezierPath(ovalIn:NSRect(x:x-r,y:y-r,width:2*r,height:2*r)).fill()
}
func make(_ name:String,_ w:Int=646,_ h:Int=660,_ draw:()->Void) throws {
    current=name
    canvasWidth=w;canvasHeight=h;outputScale=1;outputOffsetY=0
    let rep=NSBitmapImageRep(bitmapDataPlanes:nil,pixelsWide:w,pixelsHigh:h,bitsPerSample:8,samplesPerPixel:4,hasAlpha:true,isPlanar:false,colorSpaceName:.deviceRGB,bytesPerRow:0,bitsPerPixel:0)!
    NSGraphicsContext.saveGraphicsState();NSGraphicsContext.current=NSGraphicsContext(bitmapImageRep:rep)!
    let cg=NSGraphicsContext.current!.cgContext;cg.translateBy(x:0,y:CGFloat(h));cg.scaleBy(x:1,y:-1)
    NSGraphicsContext.current=NSGraphicsContext(cgContext:cg,flipped:true)
    box(0,0,CGFloat(w),CGFloat(h),ink);draw();NSGraphicsContext.restoreGraphicsState()
    try rep.representation(using:.png,properties:[:])!.write(to:out.appendingPathComponent(name+".png"))
}
func integrated(_ long:Bool=false) {
    box(42,77,208,470,paper);box(402,77,202,470,paper)
    box(163,255,320,105,accent)
    text("连接需要",48,91,556,48,ink)
    text(long ? "跨过两个区域之间的间隔":"跨过间隔",183,266,385,62,.white)
}
func separate(_ long:Bool=false) {
    text(long ? "连接需要\n跨过两个区域之间的间隔":"连接需要\n跨过间隔",48,50,550,60,.white)
    box(48,385,185,165,paper);box(413,385,185,165,paper)
    line(180,406,463,406,10,accent)
    circle(180,406,14,.white);circle(463,406,14,.white)
}
// Neutral filenames conceal input conditions and revision order from reviewers.
try make("s17") { integrated() }
try make("s24") { separate() }
try make("s08") { integrated(true) }
try make("s32") { separate(true) }
// Input probes only: change viewport width, retaining original source placement.
// These are not claimed to be completed responsive designs or old-Skill failures.
try make("s41",430) { integrated() }
try make("s05",430) { separate() }
// Replacement aspect branch: uniform contain, no clipping or letter distortion.
// The scale is a documented response to width; it also reduces visible type size.
func contain(_ draw:()->Void) {
    let scale:CGFloat=430.0/646.0
    let offset:CGFloat=(660.0-660.0*scale)/2
    outputScale=scale;outputOffsetY=offset
    let cg=NSGraphicsContext.current!.cgContext
    cg.saveGState();cg.translateBy(x:0,y:offset);cg.scaleBy(x:scale,y:scale)
    draw();cg.restoreGState()
    outputScale=1;outputOffsetY=0
}
try make("s67",430) { contain { integrated() } }
try make("s72",430) { contain { separate() } }
// Long-copy repair: preserve type, copy and line flow; enlarge the existing
// bridge so both lines lie on it and both areas remain visible above and below.
try make("s56") {
    box(42,77,208,470,paper);box(402,77,202,470,paper)
    box(163,255,412,203,accent)
    text("连接需要",48,91,556,48,ink)
    text("跨过两个区域之间的间隔",183,266,385,62,.white)
}
// Additional linguistic refinement after actual checks: preserve the full noun
// phrase instead of splitting its modifier and head. Prior renders remain.
try make("s83") {
    box(42,77,208,470,paper);box(402,77,202,470,paper)
    box(163,255,412,203,accent)
    text("连接需要",48,91,556,48,ink)
    text("跨过",183,266,385,62,.white)
    text("两个区域之间的间隔",183,357,385,42,.white)
}
try make("s90") {
    text("连接需要跨过\n两个区域之间的间隔",48,50,550,60,.white)
    box(48,385,185,165,paper);box(413,385,185,165,paper)
    line(180,406,463,406,10,accent)
    circle(180,406,14,.white);circle(463,406,14,.white)
}
try JSONSerialization.data(withJSONObject:records,options:[.prettyPrinted,.sortedKeys]).write(to:out.appendingPathComponent("text-records.json"))
print("Rendered baseline and separate copy/viewport input probes.")
