# Agent Task Handoff

[English](README.md) | **简体中文**

一个 Codex 多模型代理协作插件：Astra 负责规划和验收，Sol 负责持续实施，Luna 承接明确指定的机械工作，DeepSeek 提供可选的只读独立审查。插件只包含 Skill，不额外提供代理运行时。

版本：**0.1.3**。作者：**yueanipy**。插件及 Skill 显示名称只描述职责，不含模型名。仓库及插件/Skill 命名空间为 `agent-task-handoff`。

## 为什么使用本项目

适合需要持续实施、希望规划与验收有独立职责的任务，不必每次重新说明整套交接方式。

- **让昂贵判断集中在必要位置。** Astra 负责设计和独立验收，Sol 负责持续实施。普通小步骤、进度和额度恢复不需要回传 owner。
- **减少协调噪声，不减少证据。** 有意义的阶段交付累计包含全部未审查改动、失败检查和未完成事项，而不是每做一个小步骤就发送一次消息。
- **让中断任务可以接续。** 本地合同、状态及进度在聊天历史之外保留任务与证据，不把消息入队当作工作完成。
- **可选协作不变成强制流程。** Luna 仅承接明确选定的机械工作，DeepSeek 提供只读第二视角。小修改留在原会话，不强制形成四模型链。
- **按需加载，无额外常驻服务。** 三个轻量入口按当前操作读取支持规则，不增加 MCP 服务、后台进程或定时器；仓库 README 不作为代理运行规则安装。

目标是减少没有必要的编排，同时保留可核验的验收，而不是不计质量地追求最低 token。不能保证比单代理固定省多少额度或成功率更高，这些效果需要按实际任务测量。

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

## 下载仓库后手动修改模型

以下以**完整仓库已下载到本机**为前提。命令在仓库根目录执行，即本 README 和 `.agents/plugins/marketplace.json` 所在位置。Release 的纯插件 ZIP 不包含 marketplace 和仓库核验脚本。

### 修改源文件中的派发规则

模型路由是 Markdown 指令，不是集中式模型配置，也不会自动接入提供方。编辑 [model-verification.md](plugins/agent-task-handoff/skills/architect-implementer/references/model-verification.md) 的 **Routes and Pinning** 部分：

| 路由 | 当前模型 ID | 当前强度 |
| --- | --- | --- |
| 用户选择的架构模型 | `gpt-6-astra` | 用户选择，回传不固定强度 |
| 委派实施模型 | `gpt-6.1-sol` | `high` |
| 机械执行模型 | `gpt-6-luna` | `max` |
| 外部审查模型 | `deepseek/deepseek-flash` | `max`，须核验提供方、版本及支持情况 |

使用宿主或提供方真实支持的完整模型 ID 和强度。`deepseek-flash` 只有在确实解析到已核验 reviewer 时才可作为别名。修改文字不等于获得模型访问权，也不配置凭据。

在同一职责内更新实施或机械模型时，保留职责归属、回传设置及身份核验边界。直接使用 Sol 的任务保留用户实际设置，Astra 的强度仍由用户决定。如果用其他模型家族替换 Astra 或 DeepSeek，还需同步调整模型特定的职责、入口描述和提供方核验；不能只换一个 ID。

### 同步相关描述

搜索包内的模型名称和强度标签：

```powershell
Get-ChildItem ./plugins/agent-task-handoff -Recurse -File |
  Select-String -Pattern 'gpt-|deepseek|Sol High|Luna Max|Flash Max'
```

只修改已经不准确的描述，包括架构入口中的 `Sol High`、机械入口中的 `Luna Max`、reviewer/提供方说明，以及本 README 的角色表。角色名称变化时检查 `agents/openai.yaml`。保留 Skill ID、授权、证据、只读审查和恢复边界。身份脚本通过参数接收预期模型及强度，不是另一份写死模型的配置表。

为本地版本修改 [plugin.json](plugins/agent-task-handoff/plugin.json) 中的 `version`，让安装缓存可区分，再运行：

```powershell
pwsh -NoProfile -File .github/scripts/check-package.ps1
```

此检查不能证明替换模型或强度实际可用。

### 重新安装本地版本

修改下载的仓库**不会自动修改已安装的 GitHub 快照**。先查看登记的来源：

```text
codex plugin marketplace list
```

如果 `codex-agent-task-handoff` 已指向 GitHub 或其他本地副本，先切换这个 marketplace 的来源：

```text
codex plugin marketplace remove codex-agent-task-handoff
```

然后在修改后的仓库根目录执行：

```text
codex plugin marketplace add .
codex plugin add agent-task-handoff@codex-agent-task-handoff
```

确认来源指向当前本地仓库，安装版本是自己的修改版。活跃 worker 仍依赖来源或缓存路径时，不进行刷新，先完成工作或安全保存检查点。关闭其他 marketplace 的重复入口，再按宿主要求刷新或重新加载插件。已有聊天可能保留已加载的旧指令，因此下次经授权派发时仍须核验实际模型和强度。

此操作无需编辑安装缓存、账号凭据或全局 `config.toml` 的默认模型。修改的是本地派发规则，不会改变账号权限、现有聊天设置或公开仓库。

## 从旧版本迁移

本仓库替代原来的 `agent-workflows` 包。新安装和提示词使用 `agent-task-handoff`，安装命令不依赖旧 GitHub 仓库。使用新版入口前关闭旧插件和重复的独立 Skill。如果个人规则引用了旧命名空间，只调整相应引用，不整体复制账号配置。

迁移时不改写历史证据，也不自动重启已有 worker。活跃任务仍依赖旧本地文件或缓存路径时，保留这些路径；已有聊天可能继续使用已加载的指令，新任务使用改名后的包。任务记录独立于两个仓库，发布新版不会删除它们。
