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

以下两种方式任选一种：让其他模型修改，或自己手动修改。两者都是先改下载的源码，再按需更新安装副本，不负责接入提供方或配置 API 密钥。

### 开始前需要知道什么

- 下载并解压**完整仓库**，例如在 GitHub 点击 **Code → Download ZIP**。打开包含 `README.md`、`.agents/` 和 `plugins/` 的解压目录，不是 Release 中只有插件文件的 ZIP。
- **模型 ID** 是模型名称，例如 `gpt-6.1-sol`；**思考强度**是 `high`、`max` 等设置，不是上下文大小。哪些等级可用，以实际模型和提供方支持为准。
- **marketplace** 可以理解为“插件来源目录”：告诉 Codex 到哪里找插件。本仓库的名称是 `codex-agent-task-handoff`，不是账号，也不是付费服务；登记它不会调用模型。
- Codex 使用的是**已安装副本或缓存**，不只是你编辑的源码。若登记来源仍是 GitHub，它指向的是下载快照，不会自动改成你另行解压的本地目录。
- 个人本地修改**不必增加** `plugin.json` 的版本号。正式发布不同内容的新版本时再考虑增加。

### 方案一：让其他编程模型修改

默认仓库已经下载，并在编程模型的工作区中打开。复制下面的提示词，只在末尾添加想要的模型和思考等级，不需要填写路径或安装选项。

```text
请按下面的模型要求修改已下载的 Agent Task Handoff 插件。自行查看仓库说明，
修改对应派发规则并同步相关描述，保留其他职责和边界，不改账号、密钥、
上下文或全局默认模型。检查修改并更新本机安装副本，自行处理必要的
marketplace 来源登记，避免影响正在运行的任务。如果目标模型不受支持，
或修改要求有歧义，先说明并询问。最后简要报告改动、安装结果和未验证项。

我的模型要求：<在这里添加想使用的模型及思考等级>
```

### 方案二：直接打开文件修改（最小改动）

如果下载的仓库已经登记为本地插件来源，不需要复制文件，也不需要反复登记 marketplace。

1. 直接打开 [model-verification.md](plugins/agent-task-handoff/skills/architect-implementer/references/model-verification.md)，在 **Routes and Pinning** 中修改目标角色的 `model` 和 `effort`。例如，仅把 `high` 改为 `medium`，改变的是思考等级，不是模型。模型和等级须由宿主实际支持。
2. 在插件的 `skills/` 目录搜索旧模型或等级，同步相关指令，例如改成 Medium 后仍写着的 `Sol High`；README 中对应标签也同步。不替换无关角色，不删除身份核验。如果更换模型家族或 DeepSeek/提供方时不确定如何同步，使用方案一。
3. 等依赖该插件的委派任务结束后，更新安装副本：

```powershell
codex plugin add agent-task-handoff@codex-agent-task-handoff
```

`@` 后面应当是自己已登记的 marketplace 名称。然后按宿主支持的方式刷新或重新加载插件。已有聊天可能仍保留旧指令，下次经授权派发时核验实际设置。

**最小流程：打开源码文件 → 修改路由及相关指令 → 更新安装副本。** 本地版本号可不改。不要直接编辑安装缓存，刷新时可能被覆盖。此操作不修改全局默认模型、账号凭据或用户选择的 Astra 强度，也不会接入新的提供方。

首次登记本地来源、切换来源或需要逐步终端说明时，使用下面的方案三。

### 方案三：详细手动教程

#### 1. 修改模型和思考等级

用 VS Code 等编辑器打开完整仓库，打开 [model-verification.md](plugins/agent-task-handoff/skills/architect-implementer/references/model-verification.md)，找到靠近文件顶部的 **Routes and Pinning**。

例如，仅把被委派的 Sol 从 High 改为 Medium，将这一行：

```markdown
- Astra-led implementer: model `gpt-6.1-sol`, effort `high`.
```

改为：

```markdown
- Astra-led implementer: model `gpt-6.1-sol`, effort `medium`.
```

这只是写法示例，不是建议降低等级。如果同时换模型，就把反引号中的 ID 改成宿主实际支持的模型。这里改变的是被委派的 Sol，不是默认模型，也不是你直接选择 Sol 的会话；Astra 强度仍由你选择。

使用编辑器的目录搜索，例如 VS Code 的 **Ctrl+Shift+F**，同步相关 Skill 中的 `Sol High` 等标签，以及中英文 README 的角色表，不替换无关角色。更换模型家族或 DeepSeek 等级，还需同步职责、提供方及身份核验；不确定时用方案一，不要通过删除检查来“适配”。

#### 2. 在仓库目录打开终端

在 VS Code 点击**终端 → 新建终端**。以下命令需要 Codex CLI 可用，先运行 `codex --version`。如果提示无法识别命令，先按[Codex CLI 官方说明](https://developers.openai.com/codex/cli)安装或配置；如果不支持 `codex plugin`，需更新到支持插件的版本。

如果终端不在仓库目录，先切换目录。下面只是示例，请换成自己的解压路径：

```powershell
cd "D:\Downloads\agent-task-handoff"
```

后面命令中的 `.` 表示**终端当前目录**，其中应当有 `.agents/plugins/marketplace.json`。安装前可运行本文“核验”中的脚本，这是推荐检查，不是增加版本号或接入模型的前提。

#### 3. 登记或切换 marketplace 来源

先查看已登记来源：

```powershell
codex plugin marketplace list
```

找到 `codex-agent-task-handoff`，将它显示的根目录与当前仓库目录比较。`.tmp/marketplaces/` 下通常是工具管理的下载快照，不是自己正在编辑的仓库。根据结果只选择一种情况：

| 查看结果 | 操作 |
| --- | --- |
| 没有 `codex-agent-task-handoff` | 运行 `codex plugin marketplace add .`，登记当前本地目录 |
| 根目录已经是当前本地仓库 | 不重复登记，不移除，直接进入安装步骤 |
| 根目录是 GitHub 快照或其他目录 | 用下面两条命令切换这个 marketplace 的来源 |

**仅来源不同的时候**执行：

```powershell
codex plugin marketplace remove codex-agent-task-handoff
codex plugin marketplace add .
```

这里切换的是登记来源，不是删除下载仓库的内容。不要移除其他 marketplace。再次查看列表，确认根目录已经指向修改后的本地仓库。如果同一插件还通过其他 marketplace 启用，只保留自己准备使用的副本启用。

#### 4. 更新实际安装副本

等依赖该插件的委派任务结束，或确认可以安全刷新后，再运行：

```powershell
codex plugin add agent-task-handoff@codex-agent-task-handoff
```

这里 `agent-task-handoff` 是插件名称，`@` 后面是 marketplace 名称。这一步安装或更新 Codex 实际使用的副本，只编辑源码并不足够。本机隔离实测中，不变更版本号也能通过重新安装更新修改后的文件，因此版本号不是必改项。

然后按宿主支持的方式刷新或重新加载插件；如果需要重启，先结束其他活跃工作。已有聊天可能保留旧指令，新工作使用刷新后的入口。确认安装副本中的路由文字已经更新，再于下一次经授权派发时核验实际模型和强度；安装成功不等于已经验证过模型调用。

marketplace 机制见[官方插件说明](https://developers.openai.com/plugins/build/plugins)。本教程修改的是本机派发规则，不改变账号权限、提供方访问权或公开仓库。
