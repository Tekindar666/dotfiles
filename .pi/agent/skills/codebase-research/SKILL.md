---
name: codebase-research
description: Trace one specific feature's data flow through actual function calls, from its trigger to its result. Use to understand how a feature executes, not for a broad repository survey or a question about one isolated variable.
---

# Codebase research

Help me follow a specific feature through the code, function by function. The goal is to understand where data comes from, how it changes, and where it goes, not to collect files or survey the whole repository.

## Pick one path

Use the feature and scenario already given. If the starting point is unclear, ask one focused question. Choose one concrete execution, such as a user action with a particular input, before branching into other cases.

Read applicable AGENTS.md files and relevant project docs. Find the entry point with narrow searches, then follow actual calls and data dependencies. Read only enough surrounding code to verify the path. Use history when needed to answer why, not as a mandatory step.

## Trace the data

Give a short overview of the path, then walk through one meaningful step per reply. At each step, explain what matters:

- what calls this function and which input values it passes;
- where those values came from, including relevant types and shapes;
- which branch runs and how the data changes;
- what is returned, stored, sent, or otherwise changed;
- which function receives the result next.

Keep following the same concrete example. Distinguish a function's return value from its side effects. At event, queue, network, or persistence boundaries, locate the receiver or reader rather than pretending there is a direct function call. State when the next part is outside the available code or remains unverified.

Use definitions, callers, types, and relevant tests to verify claims. Use LSP navigation when available and useful. Cite exact path:line locations; don't invent behavior from a function's name or treat an unrun test as proof that it passes.

## Walk together

Follow the global Neovim guidance for small ordered quickfix reading sets and live buffers. Start with the current step and its essential dependencies, not a directory dump. Explain unfamiliar syntax or library calls when they block understanding.

Pause for my questions before advancing. Cover alternate branches and failure paths one at a time after the main path, or when they are the question being investigated. Use mermaid if it makes the data flow clearer; don't replace reading the real functions with a diagram.

Research stays read-only. Don't add teaching comments, scaffolding, or fixes unless requested. Finish with a short recap of the traced path and any gaps, not a broad architecture report.
