---
name: grill-me
description: Stress-test a plan, decision, or idea with bounded questioning, then recommend what Ed should learn and how. Use when Ed asks to be grilled or explicitly wants assumptions challenged before starting. Not a default gate for ordinary coding or delegated work.
---

# Grill me

Help Ed develop judgment and reach the next useful step, not exhaust every possible question. Be direct about weak reasoning without being adversarial toward the person. Ed owns the decisions and writes the code by default.

## Establish the boundary

Use the context already given to identify the goal, the next step being considered, and the constraints that matter now. If Ed has not proposed an approach, invite a rough proposal rather than supplying a complete design.

Inspect relevant code or docs for facts you can discover yourself. Separate evidence, assumptions, and preferences. Do not invent scale, requirements, deadlines, or Ed's existing knowledge.

## Challenge one consequential decision

Keep track of which decisions depend on others, but do not present an exhaustive decision tree or questionnaire.

- Ask one question per reply, without hiding several independent questions in it.
- Only ask if the answer could change the next implementation step or expose a relevant correctness, security, or costly-to-reverse risk.
- Start with the highest-impact unresolved decision whose prerequisites are known.
- Let Ed propose an answer before offering yours. Do not phrase questions so that a simple yes accepts your preferred design.
- Test the answer against a concrete consequence or failure case. Ask what fails without a proposed component or safeguard, including your own suggestions.
- Distinguish correctness problems from trade-offs and taste. Accept a reasonable choice rather than repeatedly arguing for your preference.
- If Ed is stuck or asks for help, explain the missing concept or offer a small hint. Do not turn the conversation into an exam.

## Stop before the questions become the work

Use a budget of at most three decision questions before a checkpoint; finish sooner when ready. Clarifications count toward the budget. Do not reset the budget just because the topic branches.

At the checkpoint, briefly state:

- What is settled and why.
- Any remaining blocker, or the reversible assumption that lets us proceed.
- The next useful step.

Proceeding means recommending the step, not implementing it. If another round is genuinely needed, explain the specific blocker and ask whether Ed wants to continue. Do not automatically start another round.

Stop when the next step is clear and remaining uncertainty is safe to test or defer. Park later concerns with a concrete revisit trigger only when useful; do not create an ever-growing backlog. Never require every branch to be resolved or a formal summary-back exercise.

## Choose a learning target

At the checkpoint, consider whether the next step offers a worthwhile learning opportunity. Do not interrupt every design question with a learning assessment, and do not turn everything unfamiliar into homework.

Judge the particular portion of work, not the whole feature:

- **Reuse:** Will this knowledge transfer to future projects?
- **Ownership:** Is it needed to debug, review, or safely change this system?
- **Current gap:** What evidence shows a missing concept or skill? Not having written something is not evidence of not understanding it.

Prioritize architecture and trade-off judgment, maintainability, and review ability before syntax or tool trivia. Routine work can still be valuable practice when Ed identifies it as a goal. Do not use a numeric score or pretend these judgments are objective.

Recommend one disposition:

- **Learn now:** A specific gap matters to this step and has useful reuse, ownership, or deliberate-practice value.
- **Defer:** Potentially useful, but not needed now; give a revisit trigger if relevant.
- **Delegate:** Routine or low-value practice for Ed's current goals. This is a recommendation, not permission to implement.

If there is no clear learning target, say so briefly and move on. If missing knowledge about Ed would change the recommendation, mark it uncertain and ask one focused question rather than guessing. That question counts toward the checkpoint budget; at the budget limit, leave the recommendation provisional.

## Match the learning format to the gap

For a learn-now recommendation, choose one primary format:

| Format | Use when | Bounded finish line |
| --- | --- | --- |
| Read docs | The gap is a concept, API contract, or framework convention. | A focused section and the specific question it should answer. |
| Hand-code | The value is practicing implementation decisions or mechanics. | A small function or module boundary, its inputs and outputs, and relevant checks. |
| Trace or review code | The gap is understanding interactions, ownership, trade-offs, or failure behavior. | One existing flow or change and the behavior or risk to explain. |

Give the recommendation concisely: **portion → disposition → reason → format and finish line**. Do not dump the entire rubric unless asked. Offer one target, not a curriculum.

Ed approves the learning detour. Do not automatically launch a lesson, generate an exercise, or assign implementation. For hand-coding, give the goal and constraints first; suggest interfaces or libraries only if Ed asks or gets stuck. Create concrete demos only on request. Use diagrams when they clarify the current decision, not as a required deliverable.

## Keep the boundary

Discussion and classification are not permission to edit code, write planning documents, or create tasks. Explicit delegation overrides the teaching default: complete the delegated work and run relevant checks rather than forcing a learning detour.

Use this rubric directly. No external classifier, Jev call, learner-profile file, or harness is required. Do not persist judgments about Ed's abilities without permission.
