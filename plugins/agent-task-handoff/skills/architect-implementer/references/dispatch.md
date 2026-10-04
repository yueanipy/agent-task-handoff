# Native Task Dispatch

Use available native Codex task tools within the calling workflow's authorization and host permissions. This shared procedure does not choose a new owner or override role/review limits.

Prefer the matching saved local project/checkout. A projectless recipient needs the exact shared absolute target and baseline; different worktrees do not share uncommitted edits. No copy/worktree unless requested.

Save the current checkpoint and owner ID/host/settings before dispatch. Create only the authorized first recipient or reuse the healthy canonical chat selected by the caller; replacements follow [recovery.md](recovery.md). Pin and verify according to [model-verification.md](model-verification.md).

The initial assignment includes the effective contract, current checkpoint/material pointers, recipient role, non-overlapping ownership, checks/output boundaries, callback ID/host/settings and original human authorization pointer from [boundaries.md](boundaries.md). Later messages carry material assignment/decision deltas and current pointers, not historical plans.

Record canonical recipient identity and actual outcome. A queued `clientThreadId` is not a canonical `threadId`. On creation, emit the host-required created-thread directive and perform one bounded startup check when required; then end the waiting turn without progress polling. Do not recreate an uncertain recipient or equate queueing/startup with completion.

Existing-chat messages use [delivery.md](delivery.md); creation uncertainty or tool/rejection faults use recovery. Save rework findings, affected scope and pending payload before sending; record actual delivery afterwards. A saved plan or intention to send is not dispatch.
