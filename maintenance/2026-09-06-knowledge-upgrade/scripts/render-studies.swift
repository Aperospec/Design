import AppKit
import CoreText

// Maintenance-only synthetic studies. All dimensions, copy, fonts and colors
// belong to this experiment; this program is not part of the installed skill.
let out = URL(fileURLWithPath: CommandLine.arguments[1], isDirectory: true)
let reviewerCopy = CommandLine.arguments.contains("--review")
try FileManager.default.createDirectory(at: out, withIntermediateDirectories: true)
let ink = NSColor(calibratedRed: 0.10, green: 0.16, blue: 0.19, alpha: 1)
let muted = NSColor(calibratedWhite: 0.38, alpha: 1)
let paper = NSColor(calibratedRed: 0.97, green: 0.96, blue: 0.93, alpha: 1)
let accent = NSColor(calibratedRed: 0.67, green: 0.22, blue: 0.12, alpha: 1)
let pale = NSColor(calibratedWhite: 0.88, alpha: 1)
var measures: [[String: Any]] = []
var sheet = ""
var canvasHeight: CGFloat = 0
func font(_ name: String = "PingFangSC-Regular", _ size: CGFloat = 24) -> NSFont {
    guard let f = NSFont(name: name, size: size) else { fatalError("Unavailable font: \(name)") }
    return f
}
func attrs(_ f: NSFont, _ c: NSColor = ink) -> [NSAttributedString.Key: Any] {
    let p = NSMutableParagraphStyle(); p.lineSpacing = 5
    return [.font:f, .foregroundColor:c, .paragraphStyle:p]
}
func text(_ s: String, _ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ size: CGFloat = 24,
          _ name: String = "PingFangSC-Regular", _ color: NSColor = ink) {
    if reviewerCopy && ((y < 300 && !(sheet == "06-word-image" && y == 275)) || y >= 900) { return }
    let a = NSAttributedString(string:s, attributes:attrs(font(name,size),color))
    let b = a.boundingRect(with: NSSize(width:w,height:2000), options:[.usesLineFragmentOrigin,.usesFontLeading])
    a.draw(with:NSRect(x:x,y:y,width:w,height:ceil(b.height)+8), options:[.usesLineFragmentOrigin,.usesFontLeading])
    measures.append(["sheet":sheet,"text":s,"x":x,"y":y,"width":w,"height":ceil(b.height),"font":name,"size":size,"canvasOverflow":y+b.height>canvasHeight])
}
func box(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ c: NSColor = .white) {
    c.setFill(); NSBezierPath(rect:NSRect(x:x,y:y,width:w,height:h)).fill()
}
func line(_ x: CGFloat, _ y: CGFloat, _ xx: CGFloat, _ yy: CGFloat, _ width: CGFloat = 1, _ c: NSColor = ink) {
    c.setStroke(); let p = NSBezierPath(); p.move(to:NSPoint(x:x,y:y)); p.line(to:NSPoint(x:xx,y:yy)); p.lineWidth=width; p.stroke()
}
func circle(_ x: CGFloat,_ y: CGFloat,_ r: CGFloat,_ c:NSColor=accent) {
    c.setFill(); NSBezierPath(ovalIn:NSRect(x:x-r,y:y-r,width:2*r,height:2*r)).fill()
}
func make(_ name:String,_ h:CGFloat=1000,_ draw:()->Void) throws {
    sheet=name; canvasHeight=h
    let rep=NSBitmapImageRep(bitmapDataPlanes:nil,pixelsWide:1440,pixelsHigh:Int(h),bitsPerSample:8,samplesPerPixel:4,hasAlpha:true,isPlanar:false,colorSpaceName:.deviceRGB,bytesPerRow:0,bitsPerPixel:0)!
    let context=NSGraphicsContext(bitmapImageRep:rep)!
    NSGraphicsContext.saveGraphicsState(); NSGraphicsContext.current=context
    let cg=context.cgContext; cg.translateBy(x:0,y:h); cg.scaleBy(x:1,y:-1)
    NSGraphicsContext.current=NSGraphicsContext(cgContext:cg,flipped:true)
    box(0,0,1440,h,paper); draw()
    NSGraphicsContext.restoreGraphicsState()
    try rep.representation(using:.png,properties:[:])!.write(to:out.appendingPathComponent(name+".png"))
}
func header(_ n:String,_ title:String,_ desc:String) {
    if reviewerCopy { return }
    text("DESIGN / METHOD STUDIES    ·    "+n,52,32,1336,18,"HelveticaNeue",muted)
    text(title,52,73,1336,44,"PingFangSC-Semibold")
    text(desc,52,143,1336,22,"PingFangSC-Regular",muted)
    line(52,196,1388,196,1,pale)
}
func footer(_ s:String,_ y:CGFloat=930) { if !reviewerCopy { text(s,52,y,1336,18,"PingFangSC-Regular",muted) } }

try make("01-grouping") {
    header("01","标签究竟属于谁？","同一内容、同一字号；只改变标签位置。读图任务：把每一时段与它的说明配对。")
    for (i,title) in ["原样：间距关系含混","修订：靠近所属内容"].enumerated() {
        let x:CGFloat=52+CGFloat(i)*690
        box(x,225,646,620); text(title,x+28,249,590,27,"PingFangSC-Semibold")
        text("开放工作室",x+28,309,580,42,"PingFangSC-Semibold")
        line(x+28,385,x+618,385,1,pale)
        text("10:00—11:00",x+28,420,570,32,"HelveticaNeue")
        text("11:00—12:00",x+28,590,570,32,"HelveticaNeue")
        text("观察材料与工具",x+28,i==0 ? 520:470,570,26)
        text("制作与交流",x+28,i==0 ? 690:640,570,26)
        text("地点：工作室内",x+28,775,570,20,"PingFangSC-Regular",muted)
    }
    footer("维护试验 · 内容为合成简报。几何关系可测；能否减少实际误配仍需读者测试。")
}

try make("02-quantity") {
    header("02","变大，究竟大了多少？","合成数据：甲 48、乙 72、丙 96。三个方案保留相同数值与标签。")
    let vals:[CGFloat]=[48,72,96]
    let names=["甲","乙","丙"]
    for k in 0..<3 {
        let x=52+CGFloat(k)*454
        box(x,225,428,620)
        text(["半径随数值放大","面积随数值放大","共享基线的长度"][k],x+24,249,384,25,"PingFangSC-Semibold")
        text(["故障样张","保留面积表达","用于量值比较"][k],x+24,290,370,19,"PingFangSC-Regular",muted)
        for j in 0..<3 {
            let y:CGFloat=390+CGFloat(j)*150
            text(names[j],x+24,y-15,48,24)
            if k < 2 {
                let r:CGFloat=k==0 ? vals[j]*0.62 : sqrt(vals[j]/48)*30
                circle(x+210,y,r)
            } else {
                line(x+96,348,x+96,769,1,muted)
                box(x+96,y-22,vals[j]*2.05,44,accent)
            }
            text(String(Int(vals[j])),x+342,y-17,70,24,"HelveticaNeue")
        }
    }
    footer("丙/甲：数据 = 2；左图面积 = 4；中图面积 = 2；右图长度 = 2。几何核验不等于读者误差实验。")
}

let mixed = "阅读 Reading 2026：‘字形’与 spacing。\n只有实际排出来，才能看见彼此的关系。"
let fallbackSample = "Georgia 请求：连接 Bridge 2026 → 汉字由后备字体提供"
let candidates=["PingFangSC-Regular","STSongti-SC-Regular"]
try make("03-type") {
    header("03","同字号，未必同一种阅读质感","真实字体样张：同文、同尺度、同一渲染路径。字体与字号均为本试验选择。")
    for k in 0..<2 {
        let x=52+CGFloat(k)*690
        box(x,225,646,418)
        text(candidates[k],x+24,245,592,20,"HelveticaNeue",muted)
        text("文字也是形状",x+24,300,590,48,candidates[k])
        text(mixed,x+24,405,590,26,candidates[k])
    }
    box(52,671,1336,220)
    text("实际字形来源",76,692,1200,24,"PingFangSC-Semibold")
    text(fallbackSample,76,742,1200,30,"Georgia")
    text("设置中写了 Georgia，不代表所有字形来自 Georgia。详细运行字体与字符范围见 font-runs.json。",76,813,1200,20,"PingFangSC-Regular",muted)
    footer("两种字体均可用于本次文字；这张样张不产生普遍优胜者。未进行印刷、真实读者或光学字号轴验证。")
}

func monoFont(_ size:CGFloat)->NSFont {
    let descriptor=NSFontDescriptor(name:"HelveticaNeue",size:size).addingAttributes([.featureSettings:[[NSFontDescriptor.FeatureKey.typeIdentifier:kNumberSpacingType,NSFontDescriptor.FeatureKey.selectorIdentifier:kMonospacedNumbersSelector]]])
    return NSFont(descriptor:descriptor,size:size)!
}
func width(_ s:String,_ f:NSFont)->CGFloat { (s as NSString).size(withAttributes:[.font:f]).width }
let numerals=["111.1","888.88","−7.05"]
var numeralData:[[String:Any]]=[]
try make("04-numerals") {
    header("04","等宽数字，不会自动对齐小数点","同一字体、同一等宽数字特性；只改变比较列的对齐依据。数字字符串不变。")
    let f=monoFont(46)
    for k in 0..<2 {
        let x=52+CGFloat(k)*690
        box(x,225,646,596)
        text(k==0 ? "右边对齐":"小数点对齐",x+28,249,590,28,"PingFangSC-Semibold")
        let decimalAnchor=x+344
        line(decimalAnchor,354,decimalAnchor,752,1,pale)
        for (j,s) in numerals.enumerated() {
            let before=String(s.split(separator:".")[0])
            let xx=k==0 ? x+405-width(s,f):decimalAnchor-width(before,f)
            let y:CGFloat=386+CGFloat(j)*132
            (s as NSString).draw(at:NSPoint(x:xx,y:y),withAttributes:attrs(f))
            let dot=xx+width(before,f)
            line(dot,y+63,dot,y+74,2,accent)
            text("kg",x+498,y+17,90,24,"HelveticaNeue",muted)
            numeralData.append(["layout":k==0 ? "right":"decimal","value":s,"decimalX":dot-x,"font":f.fontName])
        }
    }
    footer("齐线/旧式决定形态，等宽/比例决定字宽；这些功能是否存在仍须核对实际字体。正文不因此强制等宽。")
}

let exact="请看《材料与结构》，再读 Open Form 的图注。"
let bad=["请看《材料与结构》","，再读 Open Form"," 的图注。"]
let good=["请看《材料与结构》，","再读 Open Form 的图注。"]
try make("05-linebreak",860) {
    header("05","一处行首标点，修在哪里？","固定稿局部断行对照。保持全部字符、字体与字号；不压缩整段字距。")
    for k in 0..<2 {
        let x=52+CGFloat(k)*690
        box(x,225,646,418)
        text(k==0 ? "原样":"局部调整后",x+28,249,590,28,"PingFangSC-Semibold")
        let lines=k==0 ? bad:good
        for (j,s) in lines.enumerated() { text(s,x+28,340+CGFloat(j)*65,590,28) }
    }
    footer("精确文本逐字符比较保存在 metrics.json。此处是固定版人工断行，未验证流式排版或浏览器禁则。",723)
}

try make("06-word-image",1060) {
    header("06","一个句子，两种空间关系","同一准确文案：连接需要跨过间隔。图文并置与文字成像的构图草图。")
    for k in 0..<2 {
        let x=52+CGFloat(k)*690
        box(x,225,646,660,ink)
        if k==0 {
            text("连接需要\n跨过间隔",x+48,275,550,60,"PingFangSC-Semibold",.white)
            box(x+48,610,185,165,paper); box(x+413,610,185,165,paper)
            line(x+180,631,x+463,631,10,accent)
            circle(x+180,631,14,.white); circle(x+463,631,14,.white)
        } else {
            box(x+42,302,208,470,paper); box(x+402,302,202,470,paper)
            box(x+145,480,358,105,ink)
            text("连接需要",x+48,316,556,48,"PingFangSC-Semibold",ink)
            text("跨过间隔",x+145,491,385,62,"PingFangSC-Semibold",.white)
        }
    }
    text("图文并置",52,901,646,23,"PingFangSC-Semibold")
    text("文字进入间隔",742,901,646,23,"PingFangSC-Semibold")
    footer("概念草图，不是第三方作品改编。右侧可能更具形式联系，也可能更费解；不能凭作者解释宣称受众已读懂。",981)
}

var runs:[[String:Any]]=[]
for name in candidates+["Georgia"] {
    let sample=name=="Georgia" ? fallbackSample:mixed
    let size:CGFloat=name=="Georgia" ? 30:26
    let a=NSAttributedString(string:sample,attributes:attrs(font(name,size)))
    let ct=CTLineCreateWithAttributedString(a)
    for run in CTLineGetGlyphRuns(ct) as! [CTRun] {
        let r=CTRunGetStringRange(run)
        let d=CTRunGetAttributes(run) as NSDictionary
        let f=d[kCTFontAttributeName] as! CTFont
        runs.append(["requested":name,"sample":sample,"size":size,"actual":CTFontCopyPostScriptName(f) as String,"version":CTFontCopyName(f,kCTFontVersionNameKey) as String? ?? "unavailable","start":r.location,"length":r.length,"text":(sample as NSString).substring(with:NSRange(location:r.location,length:r.length)),"file":(CTFontCopyAttribute(f,kCTFontURLAttribute) as? URL)?.path ?? "unavailable"])
    }
}
let f=monoFont(46)
let digits=(0...9).map { ["digit":String($0),"advance":width(String($0),f)] as [String:Any] }
let metrics:[String:Any]=[
    "renderer":"AppKit + CoreText; local PNG; no browser/print/reader test",
    "quantityFormulaExpectation":["values":[48,72,96],"dataRatio":2,"faultAreaRatio":4,"correctAreaRatio":2,"lengthRatio":2,"status":"formula expectations, not measured output; see pixel-measurements.json"],
    "numerals":numeralData,"digitAdvances":digits,
    "linebreak":["source":exact,"before":bad,"after":good,"beforePreservesCharacters":bad.joined()==exact,"afterPreservesCharacters":good.joined()==exact],
    "textBounds":measures]
for (name,value) in [("metrics.json",metrics as Any),("font-runs.json",runs as Any)] {
    try JSONSerialization.data(withJSONObject:value,options:[.prettyPrinted,.sortedKeys]).write(to:out.appendingPathComponent(name))
}
print("Rendered six study sheets and measured native font runs, numeral positions, and text bounds.")
