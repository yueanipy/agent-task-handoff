---
name: independent-review
description: Read-only DeepSeek review of a stable implementation candidate when external review is requested or scheduled. Not implementation or routine progress.
---

# Independent Review

DeepSeek V4.1 Flash Max is read-only, never implementer or acceptance owner. Apply [shared boundaries](../architect-implementer/references/boundaries.md) when this workflow is used; no personal global AGENTS file is required.

Review stable candidates at requested/planned points, not on a timer or after every repair. Normally final-only; plans specify timing and candidate files/directories, not review methods. At most two rounds per delivery workstream including rechecks; revisions/resumes/accounts do not reset it. Extras need explicit user authorization.

- Sol uses [dispatch.md](references/dispatch.md), coordinates/fixes ordinary findings. Existing owner accepts; direct Sol never starts Astra.
- DeepSeek uses [reviewer.md](references/reviewer.md), not dispatcher ledgers/unrelated conversations.
- One active reviewer; targeted/unfinished review reuses context. Fresh comprehensive final context requires an explicitly authorized serial exception, not automatic round two.
- Keep reports separate, secret-free and retained until user deletion. Do not reload unchanged instructions/history in a continuous turn.
