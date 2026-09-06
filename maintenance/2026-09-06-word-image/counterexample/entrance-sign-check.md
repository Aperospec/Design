# 展览指引牌检查

成品：`entrance-sign.png`，实际读取为 800 × 800 PNG。源文件：`entrance-sign.swift`，使用 macOS AppKit/CoreText，无外部素材。

复现：在本目录执行 `/usr/bin/swift -module-cache-path /private/tmp/design-forward-swift-cache entrance-sign.swift`。

已打开实际完整 PNG：上半部两行依次为“展览入口”“请向右行”，文字无增删，未见缺字、裁切或遮挡；下半部只有一个向右的黑色实心箭头，箭尖与“向右”一致。白底、黑字、黑箭头，边缘保留正常抗锯齿。文字与箭头上下分区，未相互覆盖，未添加标题、隐喻、分页或其他文案。PingFangSC-Regular 实例可用，两行所需字形覆盖检查通过。

检查仅为本次模型对本地 PNG 的实际查看及文件尺寸核验。未进行真人试读、现场距离或打印验证，不承诺实际观众效果。未读本维护目录的研究或其他成品，未修改 Skill。
