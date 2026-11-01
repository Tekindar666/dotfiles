---
description: Review a small unstaged change against our plan without fixing it
argument-hint: "[focus or intended change]"
---
Review the small logical change I just completed. This is a mid-implementation checkpoint, not a whole-project audit or permission to implement anything.

Additional focus or intended change: ${@:-Use the current conversation's agreed goal and plan.}

Scope and evidence:
- Check the relevant AGENTS.md instructions, Git status, and unstaged tracked changes with git diff. Review the working tree against the index, not all changes against HEAD. Do not stage, discard, commit, or edit anything.
- Note relevant untracked files separately: git diff does not include them. Inspect new source/test files that belong to this change, but do not read secrets, generated files, or unrelated private state.
- If there are no unstaged changes, say so; do not silently switch to staged changes. Staged code may provide context, but is not the review target.
- Establish the intended behavior from our conversation and any relevant plan. If it is unclear, ask one focused question before judging whether the change matches it. Do not invent requirements.
- Read only the nearby callers, types, and tests needed to understand the changed behavior. Separate intentionally unfinished later steps from defects in this completed step.
- If unsaved Neovim changes may matter, read live buffers when available and clearly distinguish those from the on-disk Git diff. Never save or reload buffers for me.
- Focus on concrete correctness issues, alignment with the agreed plan, and meaningful design or maintainability problems. Avoid speculative edge cases, cosmetic nits, and unsolicited refactors.
- Run small relevant checks when safe and practical. Do not install dependencies, update snapshots, run autofixes, or modify source files. Diagnostics are not executed tests. State what was checked, what passed or failed, and what remains unverified.

Response:
- Start with either "Matches the plan; no material issues found" or "Needs improvement", only when supported by the inspected scope. This is not a guarantee that the whole feature is complete or correct.
- If it matches, briefly explain why and report verification limits. Do not manufacture suggestions to fill space.
- If improvements are needed, briefly list material findings in priority order, with exact file/line locations. Explain the most important one first: the concrete failing case, why it matters, and the direction I should take to improve it. Use hints or interfaces rather than a complete replacement implementation unless I ask.
- Keep the discussion concise and leave room for me to respond before explaining additional issues in depth.
- When connected to Neovim, publish actionable findings to the Pi-managed quickfix list with short plain-language explanations. Do not move my cursor, open windows, or change Harpoon marks.
