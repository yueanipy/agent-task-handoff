# Cross-Chat Delivery

For native messages to an existing canonical chat, in either direction. Roles, authorization and review budgets remain unchanged; creation uses [dispatch.md](dispatch.md).

Reuse applicable workflow authorization under [boundaries.md](boundaries.md); do not request fresh approval for each covered send. Send the payload once with receiver parameters from [model-verification.md](model-verification.md). Record the native tool's actual receipt/error and supplied IDs in the sender's existing owned checkpoint/report.

A clear native acceptance matching the target establishes queueing: end the handoff turn without an ACK, receipt check or waiting for recipient completion. Queueing is not execution, owner acceptance or PASS.

For an ambiguous response, use at most one immediate compact read-only direct-ID check when a canonical thread ID exists. Check the exact message, not just recipient running/idle status. If still uncertain, record unconfirmed status locally and pause that handoff; no blind resend or duplicate worker.

No fixed delay, sleep or timer; no repeated receipt/progress/completion polling, whole-history/log scan or automatic retry. Clear rejection, quota exhaustion, user interruption or unavailable tools/routing follow [recovery.md](recovery.md) locally, without failure-only callbacks or bypasses.

No per-message document, secrets or writes to another role's records. Substantive results/design decisions still include failed checks and limitations. This procedure does not guarantee delivery/model preservation or zero model/tool quota cost.
