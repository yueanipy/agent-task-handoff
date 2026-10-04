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

After downloading the **full repository**:

1. Edit **Routes and Pinning** in [model-verification.md](plugins/agent-task-handoff/skills/architect-implementer/references/model-verification.md) to change the model ID and effort. Update related names and model checks in the skills. Keep role boundaries intact; Astra effort remains user-controlled.
2. Increase the version in [plugin.json](plugins/agent-task-handoff/plugin.json).
3. With no active delegated tasks, reinstall from the repository root. If this marketplace was previously registered, first run `codex plugin marketplace remove codex-agent-task-handoff`, then:

```powershell
pwsh -NoProfile -File .github/scripts/check-package.ps1
codex plugin marketplace add .
codex plugin add agent-task-handoff@codex-agent-task-handoff
```

Refresh the plugin afterward; existing chats may retain old instructions. Use models and efforts your host actually supports. These edits do not connect a new provider or configure its API key.
