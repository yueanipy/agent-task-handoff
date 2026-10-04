# Agent Task Handoff

[English](README.md) | **简体中文**

一个 Codex 多模型代理协作插件：Astra 负责规划和验收，Sol 负责持续实施，Luna 承接明确指定的机械工作，DeepSeek 提供可选的只读独立审查。插件只包含 Skill，不额外提供代理运行时。

版本：**0.1.3**。作者：**yueanipy**。插件及 Skill 显示名称只描述职责，不含模型名。仓库及插件/Skill 命名空间为 `agent-task-handoff`。

## 本项目优势

面向长任务的可控多模型协作，重点不是启动更多代理，而是让分工、交接和最终结果都有依据。

- **分工形成闭环，而非仅拆分任务。** 规划、实施、验收各有负责人，具体返工回到同一健康执行会话，不为每次修复另开 writer。
- **按交付价值通信，而非定时上报。** 小步骤由 Sol 自行测试、修复，重要阶段累计提交全部未审查工作，让昂贵的顶层调用集中在决策和验收，不用于普通进度或额度恢复。
- **验收依靠证据，而非口头完成。** 检查与发现绑定实际候选版本，失败和未测范围不会被隐藏；消息入队、执行完成、验收通过分别记录。
- **长任务可以接续，而非依赖完整聊天历史。** 本地合同、检查点和证据索引保留当前任务，中断恢复无需重放全部对话，也不单为恢复唤醒顶层。
- **协作规模受控，而非不断增加写入者。** 每个模型、每条工作流最多一个活跃会话，禁止重叠写入，明确替换和停止边界，降低重复执行及改动冲突风险。这些是工作流防线，不是操作系统强制锁。
- **轻量接入，不强制完整模型链。** Skill 按需读取支持规则，不增加 MCP 服务、常驻进程或定时器；小修改留在原会话，辅助模型按需使用，Astra 强度仍由用户决定。

以上是设计优势，不代表已经实测优于所有同类方案。实际质量和额度节省取决于任务、模型及宿主行为。

## 功能

| 角色 | 职责 | 模型设置 |
| --- | --- | --- |
| Astra | 架构、需求、计划、小范围修改及独立验收 | 用户选择的 `gpt-6-astra`，思考强度由用户控制 |
| Sol | 持续实施、调试、集成、测试及证据交付 | 委派时使用 `gpt-6.1-sol` / `high` |
| Luna | 用户或协调模型明确指定、规则固定、几乎不需要独立判断的机械工作，工作量不限 | 委派时使用 `gpt-6-luna` / `max` |
| DeepSeek | 对候选版本及其假设进行独立只读评估 | 核验后的 DeepSeek V4.1 Flash / `max` |

- 只要求规划时就停在规划，不因为读取 Skill 而启动实施。
- 直接使用 Sol 时由 Sol 负责自己的任务，不启动 Astra；直接使用 Luna 时留在原会话，不强制形成模型链。
- Astra 可以完成小范围修改；持续委派的产品实施和返修由 Sol 承担。
- Sol 自行测试、修复小步骤，在有意义的验收阶段累计交付证据。不设置五小时计时、固定汇报次数或仅进度变化的顶层唤醒。
- 外审只指定何时审查、从哪些候选文件或目录开始；可以追踪相关依赖，不限定问题类别或审查方法。

## 使用条件

- Codex 宿主支持插件，并提供独立会话委派所需的原生创建、消息工具。
- 所选模型和必要的项目、记录路径可用。工具或模型缺失时报告阻碍，不静默换成其他执行方式。
- DeepSeek 外审需要另行配置并核验支持 Max 的 DeepSeek 提供方。本仓库不包含路由代理、API 密钥或模型接入配置。
- 身份核验辅助脚本需要 PowerShell 和可读取的本地 Codex 会话元数据。默认检查点位置面向 Windows。

### 完整外审流程需要先接入 DeepSeek

要在 Codex 内完整运行 **Astra → Sol → DeepSeek 外审 → Sol 修复 → Astra 验收**，必须先将 DeepSeek 接入为 Codex 真正可调用的模型路线，并具备所需模型、强度及会话通信能力。安装本插件**不会**自动接入 DeepSeek，也不会配置提供方、密钥或本地客户端。

未接入时，Astra/Sol 主流程仍可运行，但必要的 DeepSeek 外审会处于阻碍状态，不能宣称已完成。如果改用本机另行配置的 DeepSeek 工具，需要明确提出，例如：**“使用本机已配置的 DeepSeek 工具进行本次审查”**，并指定可访问的工具或调用方式。仅在电脑上安装客户端或保存密钥并不够。插件不会自行查找、启动本地 DeepSeek 软件；外部工具也不会自动具备 Codex 原生会话回传能力。

## 安装

本仓库的 marketplace 只提供 `agent-task-handoff`，不等于自动提交到公开 Plugins Directory。

可安装的插件位于 `plugins/agent-task-handoff/`。仓库说明、核验文件和 Git 元数据均在插件目录之外，不会作为运行规则安装。

```text
codex plugin marketplace add yueanipy/agent-task-handoff
codex plugin add agent-task-handoff@codex-agent-task-handoff
```

若使用本地下载的仓库，第一条替换为：

```text
codex plugin marketplace add ./agent-task-handoff
```

更新后按宿主提供的方式刷新或重新加载插件。如果其他 marketplace 或独立 Skill 目录中已有启用的旧副本，使用前应关闭重复入口。安装不修改默认模型、上下文大小、凭据或项目规则。

支持的安装方式见[官方插件打包文档](https://developers.openai.com/plugins/build/plugins)。

## Skill 入口

| Skill | 使用场景 |
| --- | --- |
| `$agent-task-handoff:architect-implementer` | Astra 主导的代理实施规划、委派、候选验收，或现有工作流记录整理 |
| `$agent-task-handoff:sol-luna-mechanical` | 用户或协调 Astra/Sol 明确交给 Luna 的机械工作；不启用隐式调用 |
| `$agent-task-handoff:independent-review` | 用户要求或计划中安排的稳定候选版本只读审查 |

普通问答和独立设计讨论无需加载这些工作流。各入口只读取当前操作需要的支持文档。运行规则、显示名称和简介使用英文；本 README 及英文版用于人阅读。

## 边界

- 创建、派发和回传受真实用户授权及宿主权限约束。插件不能自行授权，也不能绕过被拒绝的消息发送。
- 复用健康会话，每个模型、每条工作流最多一个活跃会话，禁止重叠写入。替换会话需要授权，以及原 writer 已停止或隔离的证据。
- 派发前保存有效合同。记录保存在插件和缓存之外，保留到用户删除；不得写入凭据或带秘密的日志。
- 区分准备、已入队、已执行和已验收。发送回执不等于实施完成或验收通过。
- 发现、检查和验收绑定实际候选版本。失败及未运行的检查须保留；阶段通过不等于整体完成。
- DeepSeek 不得修改产品文件、需求或 owner 记录，不得启动业务服务、其他代理，不能代替 owner 验收。默认以最终交付外审为主，每条工作流最多两轮，额外审查需用户授权。
- 额度中断、进度和用户停止后的恢复留在原执行会话。不自动重启已停止任务，也不为了等待或恢复而唤醒 owner。

这些是工作流规则，不是操作系统锁或确定性调度器，不能保证模型永远可用、消息送达、路由正确、全部缺陷被发现，或固定节省多少额度。

## 核验

```powershell
pwsh -NoProfile -File .github/scripts/check-package.ps1
```

检查覆盖打包结构、引用、运行规则语言及调用策略，不启动模型会话，也不证明整个委派链已通过实测。0.1.3 更新显示名称、包标识及面向用户的文档，不改变既有职责边界或模型路由；本次更名更新未重新运行自然路由及回传测试。

## 手动修改模型

下载**完整仓库**后：

1. 打开 [model-verification.md](plugins/agent-task-handoff/skills/architect-implementer/references/model-verification.md)，在 **Routes and Pinning** 中修改模型 ID 和思考强度，同步 Skill 内相关名称和模型判断。保留职责边界，Astra 强度仍由用户选择。
2. 增加 [plugin.json](plugins/agent-task-handoff/plugin.json) 的版本号。
3. 没有正在执行的委派任务时，在仓库根目录重新安装。若此前已登记这个 marketplace，先运行 `codex plugin marketplace remove codex-agent-task-handoff`，然后执行：

```powershell
pwsh -NoProfile -File .github/scripts/check-package.ps1
codex plugin marketplace add .
codex plugin add agent-task-handoff@codex-agent-task-handoff
```

完成后刷新插件；已有聊天可能仍使用旧规则。模型和强度必须由宿主实际支持，修改这些文件不会自动接入提供方或配置 API 密钥。
