# UI / 交互通用方法：一手来源短报告

核验日期：2026-09-07。用途：为 design-craft 的 UI / 交互能力准备可迁移的方法依据；不是某个平台的实施规范或完整 UX 研究体系。以下六项均实际读到注明的正文范围；没有读取其链接书籍、收费课程或全部配套资料。未修改 Skill。

## 1. MIT：先理解任务，再推导界面

- 来源：[6.831 / 6.813 Lecture 7 Notes — Task Analysis，Spring 2011](https://ocw.mit.edu/courses/6-831-user-interface-design-and-implementation-spring-2011/e9395ea03b0487fd1df5ccf1cd03775c_MIT6_831S11_lec07.pdf)。
- 实际阅读：PDF 第 4–26 页可提取的讲义正文：用户与情境、用户类别与 persona 限制、任务目标/前置条件/子任务、对象及关系/数量范围、需求分析、具体任务与本质任务、情境访谈与参与式设计。部分幻灯片标题/图示文字提取乱码，未据此作结论。
- 可迁移方法：以用户要达到的目标表述任务，列前置条件及当下所需信息；再用对象、关系与真实数量范围决定信息组织及操作方式。观察既有流程后追问“为何这样做”，避免把旧工具的步骤原封不动搬进新界面。
- 边界：这是教学方法，不是当前平台标准。对象图不等于数据库设计；CRUD 用于发现遗漏，不要求每个对象都有四类功能；persona 不代替真实用户证据。

## 2. Jakob Nielsen：把可用性原则落实到动作后的结果

- 来源：[10 Usability Heuristics for User Interface Design](https://www.nngroup.com/articles/ten-usability-heuristics/)，1994；页面注明 2024-01-30 复核。
- 实际阅读：第 1–10 条正文、提示，以及“Note from Jakob / Citing the Heuristics”；未读取所有延伸文章及海报。
- 可迁移方法：沿关键任务逐步检查：操作入口与含义是否可识别，动作后能否判断结果及下一步，错误是否有具体恢复办法；先处理代价高的错误，再处理小摩擦。保持同义动作一致，减少跨界面的记忆负担。
- 边界：原作者明确这些是广义经验准则，不是详细规范；不能凭“符合十条”证明真实可用性。取消、撤销、确认应按实际后果选择；不要机械地给每次操作添加确认框。

## 3. GOV.UK：组件复用须有适用证据

- 来源：[GOV.UK Design System — Contribution criteria](https://design-system.service.gov.uk/community/contribution-criteria/)。
- 实际阅读：“Proposing a component or pattern”“Developing a component or pattern”“Developing a community resource or tool”全文。
- 可迁移方法：先检查既有组件能否覆盖需要；提出新组件或替换旧组件时，说明重复出现的需求、与现有方案的差异及改善依据。组件应带用法与已测试情境，并在代表性用户、辅助技术和设备上检查行为，而不只统一外观。
- 边界：贡献门槛面向跨政府服务的共享系统，不能要求单个小界面先建完整设计系统。GOV.UK 的代码规范、品牌样式、支持时限及发布流程属于其治理约定，不迁移为通用要求。

## 4. W3C：无障碍应检查实际操作与语义

- 来源：[Web Content Accessibility Guidelines (WCAG) 2.2](https://www.w3.org/TR/WCAG22/)。
- 实际阅读：1.3.1–1.3.4、1.4.1、1.4.3–1.4.4、1.4.10、2.1.1–2.1.2、2.4.3、2.4.6–2.4.7、2.4.11、4.1.2–4.1.3，以及 5.1 与 5.2.1–5.2.2。
- 可迁移方法：把信息层级、名称、角色和状态作为设计内容；检查键盘能进入、操作和离开，焦点可见且顺序保留意义。放大或变窄时保留信息与功能；状态反馈也应能被辅助技术获知。只用颜色或位置表达含义会遗漏用户。
- 边界：WCAG 是 Web 标准；数值、等级和例外必须随具体条款查验，不把 CSS 尺寸转成所有平台通用尺寸。二维布局有明确例外。检查若干条款或查看截图，均不能宣称整页符合 WCAG。

## 5. Apple：适配时保留可识别的关系

- 来源：[Human Interface Guidelines — Layout](https://developer.apple.com/design/human-interface-guidelines/layout)。
- 实际阅读：检索器返回的 Apple 页面正文中“Best practices”“Visual hierarchy”“Adaptability”“Guides and safe areas”及部分“Platform considerations”。直接打开当前页面只返回 JavaScript 提示；未验证页面全部内容及所有配图。该访问范围弱于其余五项的直接正文读取，应在涉及 Apple 实施细节时重新打开当期文档。
- 可迁移方法：用空间、分组和对齐表达相关性；给关键内容足够空间，并让隐藏内容有可发现的入口。改变窗口、文字大小、语言长度或阅读方向时，重新安排界面而保留熟悉的内容与控制关系。
- 边界：Liquid Glass、全出血、安全区、平台导航转换及各设备边距属于 Apple 条件下的建议，不能成为 UI 通用风格、断点或间距规定。

## 6. Jakob Nielsen：用代表性任务观察真实误解

- 来源：[Thinking Aloud: The #1 Usability Tool](https://www.nngroup.com/articles/thinking-aloud-the-1-usability-tool/)，2012-01-15。
- 实际阅读：“Defining Thinking Aloud Testing”“Benefits of Think-Aloud”“Downsides of Think-Aloud”全文；未读取所链接书籍、课程和研究报告。
- 可迁移方法：让代表性用户完成代表性任务，观察其理解、选择与卡住的位置；主持人少干预，避免提示答案。把具体误解与设计改动对应起来，可从纸面原型到成品反复验证。
- 边界：这是定性诊断方法，不能靠小样本推断总体成功率。出声思考和主持人的提问会改变行为；受引导的片段应单独标明或剔除。Agent 自查、模拟角色、专家检查不能冒充真实用户研究。

## 最值得迁移的五条（本次综合判断）

1. **从任务推导结构。** 确认用户目标、前置条件、所需信息、对象关系与数量范围，再决定页面、导航、流程；必要时由实测修正。[依据：MIT](https://ocw.mit.edu/courses/6-831-user-interface-design-and-implementation-spring-2011/e9395ea03b0487fd1df5ccf1cd03775c_MIT6_831S11_lec07.pdf)
2. **检查完整的动作与状态变化。** 入口、动作含义、正在发生什么、结果、下一步及恢复办法应能串起来；按真实风险补齐异常情况。[依据：Nielsen](https://www.nngroup.com/articles/ten-usability-heuristics/)
3. **把组件视作有适用范围的行为约定。** 优先复用现有模式；确需新增时，说明它解决的重复问题、差异和验证范围，视觉一致只是其中一部分。[依据：GOV.UK](https://design-system.service.gov.uk/community/contribution-criteria/)
4. **适配的检验对象是信息与操作能否保留。** 在目标尺寸、文字变化和输入方式下检查顺序、可达性、语义与状态，不从一张漂亮截图推断完成。[依据：W3C](https://www.w3.org/TR/WCAG22/)、[Apple](https://developer.apple.com/design/human-interface-guidelines/layout)
5. **把设计检查与用户证据分开。** 启发式用于找疑点，任务测试用于观察实际障碍；修订应对应具体发现，并标出没有验证的人群、设备或状态。[依据：Nielsen 定性方法](https://www.nngroup.com/articles/thinking-aloud-the-1-usability-tool/)

补入 Skill 时宜保留“在当前任务需要时使用”的条件，不新增固定页数、必做全套表格、必建组件库、统一视觉样式或固定测试人数。上列操作化表述是对已读材料的有限综合，不冒充来源原文。

## 整合者补充的直接阅读

2026-09-07 直接打开并阅读 W3C ARIA APG Read Me First（角色承诺、辅助技术支持），WCAG 2.2 Understanding Reflow（意图、基本重排、应用重排与二维布局例外），Status Messages（定义、意图、动态信息及上下文变化区别）。对应 URL 已列入随 Skill 分发的 interface-method-basis.md。可迁移的是语义与行为配套、保留任务功能及检查具体技术组合；Web 阈值和例外仅在适用项目使用，不宣称原生界面合规或已执行读屏测试。
