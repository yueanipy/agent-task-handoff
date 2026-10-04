# Handoff Recovery

Read only the matching failure section. Preserve checkpoints; runtime interruption is not a design decision.

## Quota, Interruption and User Stop

`usage_limit_exceeded`, account-quota approval rejection and stopped/interrupted turns are runtime issues, not repository ACL faults or missing authorization. Save progress/unresolved owned processes when possible and report locally. No owner wakeup, replacement request, revision or owner-to-worker "continue" solely for recovery; partial work is not a completed candidate.

Quota recovery does not guarantee wakeup: continuation requires actual runtime/user resumption of the original chat. User-stopped work requires user resumption. An owner receiving a runtime-only notice must not relay a restart or create a design turn. Do not stop healthy work merely to renew identity.

Use native permission handling for genuine filesystem/network denial; involve the owner only if the remedy changes design/scope/specification. Do not claim cleanup without evidence.

## Missing or Unusable Task Tools

Check callable tools, not plugin installation flags. Preserve the handoff and report a technical blocker; authorization cannot restore tools. No silent native-subagent/nested-CLI substitution or Astra takeover of the main implementer.

For optional mechanical Luna work only, Sol may perform it unless the user explicitly required Luna; then ask before substitution. This does not replace the independent Sol workflow.

Diagnose natively within permissions, not by guessing changes to authentication/provider/context, reinstalling or clearing data. Replacement remains subject to the boundary below.

## Uncertain Creation or Delivery

[delivery.md](delivery.md) governs existing-chat messages. Failed recipient work does not prove an accepted message was lost.

For uncertain creation, use at most one compact direct-ID read-only check if a canonical ID exists; the host startup check may satisfy it. A queued `clientThreadId` is not a canonical `threadId` or verified startup. Preserve uncertainty, never recreate blindly. End the waiting turn after that check, without polling.

## Account Switching and Replacement

Resume from current state and needed plan/progress; check exact checkout and old-writer status when accessible, not full history. Local files recover context, not account access/chat ownership; inaccessible does not mean stopped.

Reuse healthy chats. Replacement requires explicit user authorization and old-writer stopped/isolated evidence, with at most one active per model/workstream and no overlapping writers. Corruption, inaccessible context, unrecoverable wrong-model state or repeated old assignments justify proposing replacement, not creating it automatically.

Never silently restart/replace user-stopped work. Actual resumption and assignment authority still apply. [model-verification.md](model-verification.md) defines new-turn checks, not revision-time freshness demands.
