# Model Verification

## Routes and Pinning

- Astra owner: selected `gpt-6-astra`; effort controlled only by the user.
- Astra-led implementer: model `gpt-6.1-sol`, effort `high`.
- Mechanical worker: model `gpt-6-luna`, effort `max`.
- Reviewer: model `deepseek/deepseek-flash`, effort `max`, verified DeepSeek V4.1 Flash provider/version/Max support. Alias `deepseek-flash` requires the same verification.

Pin dispatched Sol/Luna to their prescribed settings. Direct Sol retains its actual selected model/effort, not the delegated default. Astra callbacks target its existing chat without `model` or `thinking` overrides; other callbacks preserve actual receiver settings. Record intentional user changes, never restore stale settings over them. No silent downgrade/provider substitution or authentication/context/default changes; user choices and host constraints govern.

## Verify Once, Reuse Stable Facts

Prefer exposed actual turn metadata. Otherwise use the read-only helper:

[verify-thread-model.ps1](../scripts/verify-thread-model.ps1), resolved from this installed Skill. It uses `CODEX_HOME` when set, otherwise the current user's `.codex` directory. Run the helper without loading its source unless investigating it.

Startup verifies model/effort, assignment, exact checkout and baseline; reviewers also require provider/version/Max. A new execution turn, resumption or compaction checks current identity/assignment once; recheck broader facts only if possibly changed. Ordinary "continue" does not require full history/plan rereads. Requests/catalog/configuration are not actual-turn proof; logs prove recorded identity, not running state or completion.

A revision in the same verified continuous turn changes the contract, not identity. Use `-ExpectedTurnId` when known; never use revision send time as `-NotBeforeUtc` or manufacture a fresh turn. Timestamp bounds require a reliable expected new-turn boundary.

Mismatch or unestablishable identity stops affected work and is reported locally. A verified new turn need not stop. Use native permission handling for inaccessible logs, not guesses/restarts. Unavailable/unverified reviewer Max is not successful review.

Pinning does not prove switching bugs fixed. Wrong-model work remains unaccepted evidence, not Astra acceptance or configured external review.
