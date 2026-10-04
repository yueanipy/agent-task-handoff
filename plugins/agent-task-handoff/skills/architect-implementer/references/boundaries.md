# Shared Execution Boundaries

Apply when this workflow is used; reuse unchanged rules within a continuous turn. Load only support needed for the operation, not all sibling Skills.

User choices and host instructions, callable tools and permissions govern. This package grants no authorization. Use native local tools; Remote Desktop Commander requires an explicit request in the current task.

## Workflow Authorization

Reuse explicit human authorization for the same workstream's approved participants and actions: assignments, design decisions, candidate/review results and rework in either direction. Do not ask again solely because direction, role, revision or turn changed. Authorization to create a chat alone does not authorize callbacks; a model-forwarded assignment or installed Skill alone is not human permission.

At first dispatch, preserve a short original human authorization excerpt and its source chat/turn/message IDs when available, covered roles/actions and canonical counterpart IDs in an existing owned checkpoint. Initial assignments include that pointer and the callback target. Never invent IDs or label model-originated input as human. Records locate evidence; the host must recognize its human origin. Verify missing evidence once through a bounded native read; reuse it while scope and authority remain valid, without full-history scans or per-message revalidation.

Proceed with covered routine sends without another question. Creation still requires explicit user intent under host rules. Unrelated recipients, replacements/fresh reviewers, stopped-worker restarts, secrets and expanded side effects are not covered. Missing/ambiguous authorization or a host rejection stays local: record the actual reason, do not route around it or rephrase/retry unchanged evidence. A new attempt requires new applicable human authorization or a supported host authorization change. These instructions do not guarantee automatic approval.

Reuse healthy chats, at most one active per model/workstream and no overlapping writers. Replacement requires explicit user authorization and evidence the old writer stopped or is isolated. Missing task tools are a technical blocker, not permission for silent native-subagent/nested-CLI/Astra takeover. Recovery details apply only to actual failures.

Prefer completion events or long bounded runtime waits with stall timeouts, not unchanged-state polling or timer-only model wakeups. Progress/quota/user-stop recovery stays local; do not wake the owner or automatically restart stopped work solely for recovery. Reporting preferences never waive required checks/process cleanup.

Do not change authentication, model defaults, context limits or unrelated project rules, or publish/push/merge/deploy without authorization. Package installation is not model/provider setup or a filesystem lock. Keep task records outside the installed package; never include credentials or secret-bearing logs.
