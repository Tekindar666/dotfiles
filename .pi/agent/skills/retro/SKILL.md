---
name: workflow-retro
description: Retrospects on a completed implementation, pull request, review, QA cycle, or agentic workflow. Use when the user asks for a retro or how to improve the workflow after a task.
---

# Workflow Retro

Review the completed task using evidence from the session, git history, checks, smoke test, review, and QA feedback that is available. Ask for missing human-review or QA outcomes only when they materially affect the conclusions.

Keep the retro concise:

```markdown
## Workflow Retro

### Worked
- ...

### Friction
- ...

### Change next time
- ...
```

Focus on:

- clarification that could have been bundled or avoided
- context that should have been preserved at a phase boundary
- automation that caught a real problem or produced noise
- smoke-test gaps and work that remained manual
- recurring work worth turning into a rule, skill, or tool

Separate one-off incidents from recurring patterns. Recommend the smallest workflow change supported by the evidence. Do not modify global instructions, skills, or tools automatically; propose the change to the user first.
