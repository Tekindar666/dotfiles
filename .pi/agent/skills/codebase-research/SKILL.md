---
name: codebase-research
description: Researches a codebase at feature or subsystem level, explaining architecture, request/data flow, ownership boundaries, conventions, and git history. Use for onboarding, planning, prototyping, or answering how a feature works. Do not use for a question about one exact function or variable.
---

# Codebase Research

Explain the feature's behavior before its implementation. Follow the global pairing rules for planning checkpoints, small quickfix reading sets, and temporary uncommitted `NOTE:` annotations. Research is otherwise read-only; a walkthrough must not change behavior.

## Workflow

1. Read applicable `AGENTS.md` files and project documentation.
2. Map the repository with `find`, `tree`, or `rg --files`; identify entry points, package boundaries, tests, and configuration.
3. Search concepts and identifiers with `rg`. Prefer several narrow searches over dumping broad results.
4. Read the smallest set of files that establishes the end-to-end control and data flow.
5. Use `git log -- <path>`, `git log -S<string>`, `git blame`, and `git show` when intent or evolution matters.
6. Use LSP navigation only after locating concrete symbols whose definitions, references, implementations, or callers clarify the flow.
7. Verify important claims against code and cite `path:line`.

## Search strategy

- Default to `rg`: it is fast, recursive, respects `.gitignore`, and searches both filenames and contents well.
- Use `git grep` when only tracked files should count or when searching another revision.
- Use plain `grep` for piped text or environments without `rg`.
- Use LSP for semantic relationships, not broad discovery. It complements rather than replaces text search.
- Use git history to explain why; do not infer intent from current code alone when history is available.

## Output

Start with a short plain-language account of what the user does and how the system responds. Distinguish verified existing behavior, actual gaps, and unknowns; do not lead with abstractions or a list of files.

Give only the detail needed for the current question: where execution starts, what calls what, what changes outside the function, how failures behave, and which existing tests/examples support the explanation. Cite exact locations after explaining their purpose. Use a diagram only when requested or genuinely clarifying.

For a learning walkthrough, move from that overview to one small state or path in the agreed quickfix reading set. Trace a concrete example through the code; inspect the definition, callers, and tests when a function needs deeper treatment. Don't dump the entire subsystem into one response or treat product-level agreement as readiness to implement. The global pairing rules own the summary-back and implementation handoff.
