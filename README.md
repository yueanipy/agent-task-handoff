# Agent Task Handoff

**English** | [简体中文](README.zh-CN.md)

A multi-model agent delegation plugin for Codex, with Astra-led planning and acceptance, sustained Sol implementation, explicitly selected Luna mechanical work, and optional read-only DeepSeek review. It contains skills, not an additional agent runtime.

Version: **0.1.3**. Author: **yueanipy**. Plugin and skill display names describe their roles without model names. Repository and plugin/skill namespace: `agent-task-handoff`.

## Project Advantages

The focus is accountable multi-model collaboration for sustained work, not simply running more agents.

- **A complete delegation loop, not just task splitting.** Planning, implementation and acceptance have distinct owners. Concrete rework returns to the same healthy implementer chat instead of spawning another writer.
- **Deliverable-driven communication, not scheduled check-ins.** Small steps stay with Sol for testing and repair. Meaningful milestones combine all unreviewed work, keeping expensive owner calls focused on decisions and acceptance rather than routine status or quota recovery.
- **Evidence-backed acceptance, not verbal completion.** Checks and findings bind to the actual candidate version. Failures and untested scope remain visible; queued messages, completed execution and accepted results are separate states.
- **Recoverable long tasks, not dependence on full chat history.** Local contracts, checkpoints and evidence pointers preserve the current assignment across interruptions without requiring transcript replay or an owner wakeup solely for recovery.
- **Controlled collaboration, not unchecked writer growth.** One active chat per model/workstream, non-overlapping writes and explicit replacement/stop boundaries reduce duplicate work and conflicting edits. These are workflow safeguards, not OS-enforced locks.
- **Lightweight adoption without a forced model chain.** Skills load support on demand and add no MCP server, daemon or timer. Bounded edits stay local, helpers are optional, and Astra effort remains the user's choice.

These are design advantages, not measured claims of superiority. Actual quality and quota savings depend on the task, models and host behavior.

## Test Usage and Cost Comparison

The test used **Codex through a ChatGPT Plus subscription**. All dollar amounts below follow the supplied reports' API-equivalent calculation basis; **they are not actual Plus charges**.

Verification environment: Codex desktop **`26.930.3930.0`**, CLI **`0.160.0`**. These are the versions checked when documenting the test, not a claim about the runtime throughout the experiment.

### Recorded Agent Usage

| Agent | Recorded cumulative tokens | API-equivalent cost |
| --- | ---: | ---: |
| Astra main chat | **29,973,925** | Approximately **$73.16** |
| Sol main implementation chat | **188,004,102** | Approximately **$49.68** |

The full experiment recorded **219,887,291 tokens**, equivalent to approximately **$123.62** on the reports' API calculation basis. The table lists only the two main chats; the experiment total includes all recorded calls.

Cumulative tokens include cached input and repeatedly carried conversation context, not an equal amount of newly generated content.

### Mixed Workflow and Single-Model Estimates

| Approach | Cumulative tokens | API-equivalent cost | Basis |
| --- | ---: | ---: | --- |
| Mixed workflow | **219.887M** | **$123.62** | Recorded usage; cost conversion |
| Astra High only | Approximately **211.370M** | Approximately **$344.81** | Estimate; not rerun |
| GPT-6.1 Sol High only | Approximately **211.370M** | Approximately **$48.84** | Estimate; not rerun |

The single-model comparison assumes **211.370M** tokens of effective work after excluding cross-chat communication and delegation-specific Skill context, while retaining normal implementation, testing and necessary recovery records. It is a cost estimate, **not evidence that different models would consume the same tokens or achieve the same quality**.

**Test-only notice:** This is a local test case provided for reference, not a guarantee that the workflow will work or reproduce these results on another machine. Compatibility, model/tool availability, quality and quota savings may differ. Users must verify their own environment, assess risks and keep appropriate backups. The plugin is provided as-is; to the extent permitted by applicable law, the author is not responsible for losses arising from its use.

## What It Does

| Role | Responsibility | Route |
| --- | --- | --- |
| Astra | Architecture, requirements, plans, bounded edits and independent acceptance | Selected `gpt-6-astra`; effort controlled by the user |
| Sol | Sustained implementation, debugging, integration, tests and evidence | Delegated `gpt-6.1-sol` / `high` |
| Luna | Explicitly selected, fixed-rule mechanical work of any volume with little independent judgment | Delegated `gpt-6-luna` / `max` |
| DeepSeek | Independent read-only assessment of the candidate and its assumptions | Verified DeepSeek V4.1 Flash / `max` |

- A plan-only request stays plan-only. Reading the skill does not start implementation.
- Direct Sol owns its task and never starts Astra. Direct Luna stays local; there is no mandatory model chain.
- Small bounded edits can stay with Astra. Sustained delegated product implementation and repairs stay with Sol.
- Sol tests and fixes local substeps, then delivers cumulative evidence at meaningful acceptance milestones. There is no five-hour timer, fixed reporting quota or progress-only owner wakeup.
- External review identifies when to review and which candidate files/directories to start from. Relevant dependencies may be inspected; finding categories and review methods are not prescribed.

## Requirements

- A Codex host that supports plugins and the native chat creation/messaging tools needed for independent-chat delegation.
- Access to the selected models and the required checkout/record paths. Missing tools or models are reported as blockers, not silently replaced by another execution route.
- DeepSeek review additionally requires a separately configured, verified DeepSeek provider with Max support. This repository contains no provider proxy, API key or model setup.
- The identity helper uses PowerShell and readable local Codex session metadata. The default checkpoint location is Windows-oriented.

### DeepSeek Setup Is Required for the Full Review Flow

To complete the full **Astra → Sol → DeepSeek review → Sol fixes → Astra acceptance** flow inside Codex, DeepSeek must first be connected as an actually callable Codex model route, with the required model/effort and chat messaging available. Installing this plugin does **not** connect DeepSeek or configure its provider, credentials or a local client.

Without that connection, the Astra/Sol workflow can still run, but a required DeepSeek review remains blocked and must not be reported as completed. To use a separately configured local DeepSeek tool instead, explicitly request it, for example: **“Use my locally configured DeepSeek tool for this review,”** and identify the accessible tool/call method. Having a client or key on the computer is not enough. The plugin does not automatically discover or launch local DeepSeek applications, and an external tool does not automatically provide native Codex chat callbacks.

## Install

This repository exposes only `agent-task-handoff` through its own marketplace. It is not an automatic submission to the public Plugins Directory.

The installable package is `plugins/agent-task-handoff/`. Repository documentation, validation files and Git metadata are outside that package and are not installed as runtime instructions.

```text
codex plugin marketplace add yueanipy/agent-task-handoff
codex plugin add agent-task-handoff@codex-agent-task-handoff
```

For a local checkout, replace the first command with:

```text
codex plugin marketplace add ./agent-task-handoff
```

Use the host's plugin refresh/reload flow after updates. If an older copy of these skills is enabled through another marketplace or a standalone skill folder, disable that duplicate before use. Installation does not change model defaults, context limits, credentials or project instructions.

See the [official plugin packaging documentation](https://developers.openai.com/plugins/build/plugins) for supported marketplace installation.

## Skill Entry Points

| Skill | Use |
| --- | --- |
| `$agent-task-handoff:architect-implementer` | Astra-led agent implementation planning, delegation, candidate acceptance, or existing workflow-record organization |
| `$agent-task-handoff:sol-luna-mechanical` | Mechanical work explicitly assigned to Luna by the user or coordinating Astra/Sol; implicit invocation is disabled |
| `$agent-task-handoff:independent-review` | Requested or scheduled read-only review of a stable candidate |

Ordinary questions and standalone design discussion do not require these workflows. Each entry loads supporting instructions only for the current operation. Runtime instructions, display names and descriptions are English. This README and its Chinese translation are human-facing documentation.

## Boundaries

- Explicit human authorization and host permissions govern creation, assignments and callbacks. The plugin cannot grant permissions or bypass a rejected send.
- Reuse healthy chats, with at most one active chat per model/workstream and no overlapping writers. Replacement requires authorization and stopped/isolated evidence for the previous writer.
- Persist the effective contract before dispatch. Records stay outside the plugin/cache and are retained until user deletion; credentials and secret-bearing logs do not belong in them.
- Keep prepared, queued, executed and accepted states distinct. A delivery receipt is not implementation completion or acceptance.
- Bind findings, checks and acceptance to the actual candidate. Failed or unrun checks remain visible; stage acceptance is not overall completion.
- DeepSeek cannot modify product files, requirements or owner records, launch business services or other agents, or become the acceptance owner. Review normally runs at final delivery, with at most two rounds per workstream unless the user authorizes more.
- Quota interruptions, progress and user-stop recovery stay local. Do not automatically restart stopped work or wake the owner merely to wait or recover.

These are workflow instructions, not OS locks or a deterministic scheduler. They cannot guarantee model availability, delivery, correct routing, complete defect detection or a fixed amount of quota savings.

## Validation

```powershell
pwsh -NoProfile -File .github/scripts/check-package.ps1
```

This checks packaging, references, runtime language and invocation policy; it does not run model chats or prove end-to-end delegation. Release 0.1.3 updates display names, package identifiers and human-facing documentation, not the established role boundaries or model routes. Natural routing and callback behavior have not been rerun for this naming update.

## Change Models Locally

Choose either an AI-assisted edit or a manual edit. Both modify the downloaded source, then update the installed copy if needed. They do not configure a provider or API key.

### Before You Start

- Download and extract the **full repository**, for example with GitHub's **Code → Download ZIP**. Open the extracted folder containing `README.md`, `.agents/` and `plugins/`, not the plugin-only release ZIP.
- **Model ID** identifies the model, such as `gpt-6.1-sol`. **Effort** is its reasoning setting, such as `high` or `max`; it is not a context limit. Supported settings depend on the actual model/provider.
- A **marketplace** is a catalog telling Codex where to find the plugin. Here its name is `codex-agent-task-handoff`; it is not an account or a paid service. Registering it does not run models.
- Codex uses an **installed copy/cache**, not just the files you edited. A registered GitHub source still points to its downloaded snapshot, not your separate local folder.
- You do **not** have to increase `plugin.json`'s version for a personal local edit. A version bump is useful when publishing a distinct release.

### Option 1: Ask Another Coding Model

With the downloaded repository open in your coding model's workspace, use this prompt. Only add the models and reasoning levels you want at the end; no path or installation options are required.

```text
Please update the downloaded Agent Task Handoff plugin to match my model choices
below. Read the repository guidance, edit the relevant dispatch rules and matching
descriptions, and preserve all other roles and boundaries. Leave accounts,
credentials, context limits and global model defaults unchanged. Check the edits
and update the local installed copy, handling any necessary marketplace registration
without disrupting active tasks. If a requested model is unsupported or the change
is ambiguous, explain and ask. Finish with a brief report of changes, installation
results and anything not verified.

My model choices: <add your desired models and reasoning levels here>
```

### Option 2: Open the File Directly (Minimal Edit)

If the downloaded repository is already registered as your local plugin source, no copying or repeated marketplace registration is needed.

1. Open [model-verification.md](plugins/agent-task-handoff/skills/architect-implementer/references/model-verification.md) directly. Under **Routes and Pinning**, change the intended route's `model` ID and `effort`. For example, changing only `high` to `medium` changes the reasoning level, not the model. Use settings your host actually supports.
2. Search the plugin's `skills/` folder for the old model/level and synchronize relevant instructions, such as `Sol High` if the new effort is Medium. Update matching README labels too. Do not replace unrelated roles or remove identity checks. For model-family or DeepSeek/provider changes you are unsure about, use Option 1.
3. After delegated tasks depending on the plugin have ended, update the installed copy:

```powershell
codex plugin add agent-task-handoff@codex-agent-task-handoff
```

The part after `@` must be your registered marketplace name. Then refresh/reload the plugin as supported by your host. Existing chats may retain old instructions; verify actual settings on the next authorized dispatch.

**In short: open the source file → change the route and matching instructions → update the installed copy.** A local version bump is optional. Do not edit the installation cache directly: a refresh may overwrite it. This does not change global defaults, account credentials or your selected Astra effort, and it does not connect a new provider.

For first-time registration, source switching or step-by-step terminal guidance, use Option 3 below.

### Option 3: Detailed Manual Setup

#### 1. Change the Model and Effort

Open the full repository in an editor such as VS Code. Open [model-verification.md](plugins/agent-task-handoff/skills/architect-implementer/references/model-verification.md) and find **Routes and Pinning** near the top.

For example, to change only delegated Sol's effort from High to Medium, replace:

```markdown
- Astra-led implementer: model `gpt-6.1-sol`, effort `high`.
```

with:

```markdown
- Astra-led implementer: model `gpt-6.1-sol`, effort `medium`.
```

This is a syntax example, not a recommendation to lower effort. To change the model too, replace the ID inside backticks with a model your host actually supports. It affects delegated Sol, not your default model or a directly selected Sol chat. Astra effort remains selected by you.

Use the editor's folder search, for example **Ctrl+Shift+F** in VS Code, to update matching labels such as `Sol High` in the relevant Skill and both README tables. Do not replace unrelated roles. Changing a model family or DeepSeek effort also requires consistent ownership/provider/identity checks; use Option 1 if unsure rather than removing checks.

#### 2. Open a Terminal in the Repository Folder

In VS Code, select **Terminal → New Terminal**. The commands below need Codex CLI available. Run `codex --version` first; if it is not recognized, install/configure [Codex CLI](https://developers.openai.com/codex/cli) before continuing. If `codex plugin` is unsupported, update to a plugin-capable version.

If the terminal is in another folder, change directories. This path is only an example; replace it with your extracted repository folder:

```powershell
cd "D:\Downloads\agent-task-handoff"
```

The `.` in the next commands means **this current folder**. It must contain `.agents/plugins/marketplace.json`. The repository validation described above is optional but recommended before installation.

#### 3. Register or Switch the Marketplace Source

First inspect the registered sources:

```powershell
codex plugin marketplace list
```

Find `codex-agent-task-handoff` and compare its listed root with your current repository folder. A path under `.tmp/marketplaces/` is typically a managed snapshot, not your edited checkout. Choose exactly one case:

| What the list shows | What to do |
| --- | --- |
| No `codex-agent-task-handoff` entry | Register the local folder with `codex plugin marketplace add .` |
| Its root is already this local folder | Skip registration and removal; continue to installation |
| Its root is a GitHub snapshot or another folder | Switch only this marketplace with the two commands below |

For the **different-source case only**:

```powershell
codex plugin marketplace remove codex-agent-task-handoff
codex plugin marketplace add .
```

This changes the registered source, not the downloaded repository's contents. Do not remove unrelated marketplaces. List the sources again and confirm the root is your edited folder. If the same plugin is enabled through another marketplace, keep only the intended copy enabled.

#### 4. Update the Installed Copy

Wait until delegated tasks using this plugin have ended or can safely tolerate the refresh. Then run:

```powershell
codex plugin add agent-task-handoff@codex-agent-task-handoff
```

Here `agent-task-handoff` is the plugin name and the part after `@` is the marketplace name. This installs or refreshes the copy Codex uses; editing source alone is not enough. Same-version reinstall refreshed changed files in our local test, so a version bump is not mandatory.

Refresh/reload the plugin as supported by your host. If a restart is needed, finish other active work first. Existing chats may retain old instructions; use the refreshed entries for new work. Confirm the installed route text reflects your edit, then verify actual model/effort on the next authorized dispatch. Installation success alone is not proof of a model invocation.

Marketplace behavior is documented in the [official plugin guide](https://developers.openai.com/plugins/build/plugins). This procedure changes local dispatch instructions, not account permissions, provider access, or the public repository.
