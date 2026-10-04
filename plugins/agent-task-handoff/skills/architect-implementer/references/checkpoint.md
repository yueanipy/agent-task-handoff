# Current Checkpoints and History

## Files and Ownership

Before dispatch, save a unique workstream in the supplied record root; for new work without one, use the current user's Windows Documents directory plus `Codex/handoffs/workstreams`. Resolve Documents through the OS, not a hardcoded username. Resume existing work at its recorded absolute path, not a newly inferred location. Records must stay outside plugin/cache directories:

- `plan.md`: effective contract: objective, necessary context, scope/exclusions, decisions, implementation/acceptance evidence, exact checkout/baseline and assignment ID/revision. Scheduled external review records timing and candidate files/directories, not review methods or finding categories.
- `state.json`: owner-controlled current assignment/revision, target/baseline, owner/worker IDs/hosts/actual settings, delivery and acceptance with durable pointers. Include `schemaVersion: 1`, initial `status: "active"`, UTC ISO 8601 `createdAtUtc`, and `completedAtUtc: null` until overall acceptance.
- `progress.md`: worker-controlled current changes/checks, pending work/processes/blockers, next safe action and evidence paths.
- `outcome.md`: owner final accepted outcome after overall PASS.

Astra-led: Astra owns plan/state/outcome (`managedBy: architect-implementer`), Sol main progress; standalone Astra-to-Luna gives main progress to Luna. Direct Sol-to-Luna: Sol owns plan/state/outcome (`managedBy: sol-luna-mechanical`), Luna progress. Nested Luna uses `luna-progress.md`; Sol records its identity/settings and aggregate result in main progress. External review uses a separate report and Sol-owned `review-dispatch.json`.

No concurrent rewrites or writes to another role's records. Authorized maintenance of idle checkpoints identifies provenance without impersonating a producer, accepting work or resuming chats. Exclude credentials/secret-bearing logs; retain until user deletion.

## Artifact Organization

Only for plan-based handoffs producing many process documents, not ordinary messages, standalone plan/document editing or general project docs.

- One execution directory per independent plan; revisions/rework/resume stay there. Later independent plans use their own materials; read older workstreams only for dependencies/evidence.
- Pass that directory in existing assignments. Keep new process notes/reports/logs there, using history/evidence as appropriate, not project/docs roots. Preserve ownership, active entrypoints and authorized fixed output paths; link outputs that must stay elsewhere.
- Sol keeps purpose/artifact pointers in an existing owned record. No per-message documents, transcripts or duplicate ledgers; retain meaningful decisions/version-bound evidence.
- Organize at meaningful results, pauses or delivery, without extra chats/wakeups or unchanged-directory scans.
- No automatic cleanup. Before user-requested deletion, check active writers/dependent references and explain lost recovery/evidence.

## Effective Contract and Current Entry

Keep entrypoint filenames stable. Merge design/scope changes into one effective plan, retaining earlier requirements still in force and marking replacements/exceptions. The latest revision alone is not the contract; "continue" does not authorize a product-policy change.

Revise only for changed design/scope/contracts, not status, turns, recovery or housekeeping. Preserve meaningful prior snapshots before replacement; keep chronology in history, read only for disputes, missing requirements, regressions or evidence.

State is the current owner-status entry, with plan/progress/evidence pointers, not a duplicate chronology. Resume/diagnostic entry files point to it rather than retaining competing current instructions. Owner acceptance can supersede a worker's delivery-time "awaiting acceptance" without rewriting that worker's history.

## Evidence and State

Update progress for meaningful results, pauses and delivery, not every operation. Keep failed-run references, applicable source/output versions, run IDs and limitations; raw logs and superseded detail remain at linked paths.

Distinguish worker reports, independent owner checks and accepted outcomes. Date process/port/permission observations and their source: old observations are not live proof, nor a stopped listener proof all owned processes exited. `active` means unfinished, not running. Keep transient observations in worker progress, not unqualified live owner-state claims.

Initial baseline hashes are not current hashes after edits. Bind checks to the actual run/candidate; keep failed and unrun checks visible. External-review status separates unavailable, unfinished and completed, with reports/finding disposition; its round ledger remains separate. Extract relevant fields from native outputs, whose caps may not trim nested items.

Keep delivery (prepared/not-sent, queued, unconfirmed), execution and acceptance distinct; queueing proves neither execution nor acceptance. Do not collapse them into one "done" value. Preserve canonical IDs, never treating queued client IDs as canonical.

## Delivery and Resume

Persist the initial contract before dispatch; later messages use material deltas/current pointers. Save pending rework and actual delivery: interrupted findings or an intention to send do not prove dispatch.

On resume, read current state first, then only needed plan/progress/changed evidence; recover the full effective contract when missing or uncertain. Do not replay history, require full unchanged rereads or create status-only callbacks. Identity uses [model-verification.md](model-verification.md); actual failures/replacement use [recovery.md](recovery.md).

Persistence failure is a limitation, not durable recovery. Do not repeatedly paste an expanding plan. Cleanup cannot invent revisions, delivery success or a worker restart. Astra-led cumulative packets use [communication.md](communication.md).
