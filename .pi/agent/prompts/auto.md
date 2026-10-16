---
description: Delegate the agreed implementation through a draft PR in this session
argument-hint: "[feature context]"
---
Take the agreed feature through implementation, validation, commit, push, and a draft PR in this session. I am delegating the core implementation as well as supporting work for this task; all global safety and scope rules still apply.

Before editing, inspect the code and confirm any missing scope, design, validation, starting base/remote, and PR destination together. Don't repeat decisions already established. Push back on unsafe or unnecessary complexity and identify useful smaller PR boundaries without forcing a stack.

Proceed through routine implementation details yourself. Stop for material scope/design/risk changes or ambiguous business intent. Report the resulting diff, validation, remaining uncertainty, and proposed How to Test text. Do not spawn another agent, deploy/sync staging, merge a PR, or clean up worktrees unless I explicitly request it.

Feature context:

${@:-Use the agreed feature context from this conversation; if none exists, ask for it before doing anything.}
