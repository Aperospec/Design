# 界面方法依据与适用范围

这些资料支持条件性的设计判断。技能中的工作步骤是有限综合，不是教材原文、完整课程或已证实的普遍效果。规范的具体条款在对应项目使用时核对版本、等级和例外；项目的实现规范、风格及数值不进入通用默认。

| 专业依据 | 对方法的作用 | 范围与限制 |
|---|---|---|
| MIT 6.831/6.813，2011，[Task Analysis 讲义](https://ocw.mit.edu/courses/6-831-user-interface-design-and-implementation-spring-2011/e9395ea03b0487fd1df5ccf1cd03775c_MIT6_831S11_lec07.pdf)，用户、任务、对象与需求分析 | 从目标、前置条件、对象关系和数量范围形成界面结构 | 教学方法；用户假设需验证，对象分析不等于数据库或必做全部增删改查 |
| Jakob Nielsen，[10 Usability Heuristics](https://www.nngroup.com/articles/ten-usability-heuristics/)，十项准则 | 状态可见、系统与用户语言匹配、一致性、控制、错误预防与恢复 | 广义经验准则，需转成具体任务上的检查；不是完整交互规范或用户测试替代品 |
| GOV.UK Design System，[Contribution criteria](https://design-system.service.gov.uk/community/contribution-criteria/)，组件/模式的提议与开发标准 | 组件应解决重复需求，说明适用情况并有实际使用证据 | 仅迁移复用与验证思路；其政府服务样式、代码治理和贡献门槛不通用 |
| W3C，[WCAG 2.2](https://www.w3.org/TR/WCAG22/)，信息关系、颜色、文字变化、重排、键盘、焦点、名称角色状态及状态消息 | 无障碍涉及信息与操作的实际可达性 | Web 标准；局部检查不能宣称整页合规，原生界面另查适用规范 |
| W3C，[Reflow 解释](https://www.w3.org/WAI/WCAG22/Understanding/reflow.html)，意图与二维布局例外；[Status Messages 解释](https://www.w3.org/WAI/WCAG22/Understanding/status-messages.html)，意图 | 在适配和动态反馈中保留意义与功能 | Understanding 是解释资料；二维内容的例外不自动扩展到外围控件 |
| W3C ARIA APG，[Read Me First](https://www.w3.org/WAI/ARIA/apg/practices/read-me-first/)，角色承诺与辅助技术支持 | 语义必须配套真实行为，并验证目标技术组合 | 示例不是全部生产兼容性保证；ARIA 不自动提供键盘行为 |
| Apple HIG，[Layout](https://developer.apple.com/design/human-interface-guidelines/layout)，Visual hierarchy / Adaptability | 布局变化后保留可识别的内容与控制关系 | Apple 平台指导；系统样式、安全区、设备参数不作为其他平台默认 |
| Jakob Nielsen，[Thinking Aloud](https://www.nngroup.com/articles/thinking-aloud-the-1-usability-tool/)，定义与局限 | 用代表性任务观察理解障碍，减少主持人引导 | 定性方法受出声与干预影响；模型走查不是参与者证据，小样本不能给出总体成功率 |

以上基础连接视觉传达、人机交互与可用性工程；不能以资料名称或机构声誉替代设计判断。任务分析不替代产品目标，启发式检查不替代实际操作，组件库不替代具体内容，技术检查不替代用户理解。
