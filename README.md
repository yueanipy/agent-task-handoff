# Agent Task Handoff

**English** | [简体中文](README.zh-CN.md)

A multi-model agent delegation plugin for Codex, with Astra-led planning and acceptance, sustained Sol implementation, explicitly selected Luna mechanical work, and optional read-only DeepSeek review. It contains skills, not an additional agent runtime.

Version: **0.1.3**. Author: **yueanipy**. Plugin and skill display names describe their roles without model names. Repository and plugin/skill namespace: `agent-task-handoff`.

## Why Use This Project

Use it for sustained work where planning, implementation and acceptance benefit from distinct roles, without having to repeat the handoff instructions for every task.

- **Keep expensive judgment focused.** Astra designs and independently accepts; Sol handles sustained implementation. Routine substeps, progress and quota recovery do not require owner callbacks.
- **Reduce coordination noise without dropping evidence.** Meaningful milestone packets combine all unreviewed changes, failed checks and open work rather than sending an update after every small step.
- **Make interrupted work recoverable.** Local contracts, state and progress preserve the assignment and evidence outside chat history, without treating a queued message as completed work.
- **Keep optional help optional.** Luna is explicitly selected for mechanical work; DeepSeek supplies a read-only second perspective. Small edits stay local, and there is no forced four-model chain.
- **Load guidance only when needed.** Three small skill entries lead to operation-specific support. The package adds no MCP server, daemon or timer, and repository READMEs are not installed as agent instructions.

The goal is less unnecessary orchestration with accountable acceptance, not the lowest token count at any cost. It is not a guarantee of savings or higher success rates than a single agent; those outcomes need task-specific measurement.

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

## Customize Models in a Downloaded Repository

These instructions assume the **full repository** is already on your computer. Run commands from its root, where this README and `.agents/plugins/marketplace.json` reside. The release's plugin-only ZIP does not include that marketplace or repository validation script.

### Edit the Source Policy

The routes are Markdown instructions, not a central model configuration or automatic provider setup. Edit [model-verification.md](plugins/agent-task-handoff/skills/architect-implementer/references/model-verification.md), specifically **Routes and Pinning**:

| Route | Current model ID | Current effort |
| --- | --- | --- |
| Selected architect | `gpt-6-astra` | User-selected; do not hardcode callback effort |
| Delegated implementer | `gpt-6.1-sol` | `high` |
| Mechanical worker | `gpt-6-luna` | `max` |
| External reviewer | `deepseek/deepseek-flash` | `max`; provider/version/support must be verified |

Use an exact model ID and effort your host/provider actually supports. `deepseek-flash` is only an alias when it resolves to the verified reviewer. Changing text does not grant model access or configure its credentials.

For an implementer/worker model update within the same role, preserve role ownership, callback settings and verification boundaries. Direct Sol keeps its selected settings; Astra effort remains the user's choice. Replacing Astra or DeepSeek with a different model family also requires updating the model-specific ownership, discovery and provider checks; changing one ID alone is insufficient.

### Keep Labels Consistent

Search the package for model names and effort labels:

```powershell
Get-ChildItem ./plugins/agent-task-handoff -Recurse -File |
  Select-String -Pattern 'gpt-|deepseek|Sol High|Luna Max|Flash Max'
```

Update only descriptions that became inaccurate, including `Sol High` in the architect entry, `Luna Max` in the mechanical entry, reviewer/provider wording and this README's role table. Check `agents/openai.yaml` if a role label changes. Keep skill IDs, authorization, evidence, read-only review and recovery boundaries intact. The identity script accepts expected settings as parameters; it is not another hardcoded model registry.

Increment `version` in [plugin.json](plugins/agent-task-handoff/plugin.json) for your local variant so its install cache is distinguishable, then validate:

```powershell
pwsh -NoProfile -File .github/scripts/check-package.ps1
```

This check does not prove that the replacement model or effort is available.

### Install Your Local Variant

Edits to a downloaded repository do **not** automatically change an installed GitHub snapshot. Inspect the registered source first:

```text
codex plugin marketplace list
```

If `codex-agent-task-handoff` is already registered to GitHub or a different checkout, switch that marketplace source before installing:

```text
codex plugin marketplace remove codex-agent-task-handoff
```

Then, from your modified repository root:

```text
codex plugin marketplace add .
codex plugin add agent-task-handoff@codex-agent-task-handoff
```

Confirm the listed source is your local repository and the installed version is your variant. Do not run a source/cache refresh while active workers depend on it; finish or safely checkpoint that work first. Disable duplicate copies from other marketplaces, then refresh/reload the plugin as required by your host. Existing chats can retain previously loaded instructions, so verify actual model/effort on the next authorized dispatch.

Do not edit the installed cache, account credentials or global `config.toml` model defaults for this operation. This changes the local dispatch policy, not account permissions, existing chat settings or the public repository.

## Moving from the Previous Package

This repository replaces the previous `agent-workflows` package. New installs and prompts use `agent-task-handoff`; no installation command depends on the previous GitHub repository. Disable the old plugin and duplicate standalone skills before using the new entries. If personal instructions name the old namespace, update those references, without copying a full account configuration.

Do not rewrite historical evidence or automatically restart existing workers during migration. Preserve old local files/cache paths while active assignments depend on them; existing chats may retain their loaded instructions. New work uses the renamed package. Task records remain separate from either repository and are not deleted by publishing this package.
