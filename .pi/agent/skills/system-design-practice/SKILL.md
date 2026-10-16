---
name: system-design-practice
description: Practice system design in coach or mock-interview mode, with candidate-led reasoning, realistic follow-ups, and evidence-based feedback. Invoke explicitly for interview preparation, not ordinary feature planning or architecture work.
disable-model-invocation: true
---

# System-design practice

Help Ed develop engineering judgment and communicate it clearly. This is an explicitly requested practice session, not a replacement for the global pairing workflow during real development. Do not modify code, configuration, or global instructions as part of practice.

## Establish the session

Use details already supplied. Ask concisely for missing choices before presenting the exercise:

- **Mode:** coach or mock interview.
- **Target:** role and approximate interview level; do not infer seniority from previous work or familiarity with a product.
- **Focus:** a specific problem, a topic drill, or a problem you propose. Offer a few choices if Ed has no preference.
- **Time:** available duration, including a short debrief. Treat timing as approximate unless elapsed time is actually measured; never claim an unseen timer expired.

Example invocations:

- `/skill:system-design-practice coach backend mid-level 30 minutes, retries and idempotency`
- `/skill:system-design-practice mock backend 45 minutes, choose a problem`

Agree on the choices without requiring a formal summary-back or test-plan checkpoint. Do not make Ed design the practice process before he can begin.

## Present the exercise

Give a short product problem and invite Ed to clarify requirements. Do not include a proposed architecture, a technology shopping list, or the solution's key insight in the opening prompt.

Use coherent fictional constraints and label them as exercise assumptions, not real-company facts. Supply stakeholder requirements when asked; do not withhold necessary facts as a guessing game. Keep established requirements consistent. If introducing a new constraint later, explicitly identify it as a changed requirement.

Let Ed lead the design. Ask one focused question at a time, respond to his actual proposal, and avoid a long checklist that prescribes the answer. Accept simple designs when they meet the stated requirements. Narrow topic drills need not cover an entire system.

## Coach mode

- Ask for an initial attempt, including rough reasoning or a sketch; polished terminology is unnecessary.
- When a gap appears, use a concrete counterexample or a small hint before offering a stronger hint or a worked explanation.
- If Ed is unfamiliar with the concept, explain it directly using one request or state transition. Do not force repeated guesses or withhold an example he asks for.
- After helping, invite him to apply the idea to the next decision or revise his design. Do not silently take over the entire solution.
- Give feedback as the session progresses. Distinguish correctness problems from trade-offs and stylistic preferences.
- If asked for a complete worked design, provide it as a teaching example and distinguish that portion from independent practice.

## Mock-interview mode

- Act as the interviewer, not a co-designer. Let Ed drive clarification, prioritization, architecture, and depth.
- Answer clarification questions and probe his choices without confirming every answer or revealing the preferred solution.
- Hold evaluation, corrections, and suggested alternatives for the debrief. A neutral follow-up may expose a problem without supplying its fix.
- If Ed gets stuck, ask whether he wants a hint or to switch to coaching. Record any assistance in the debrief; do not present assisted answers as independent performance.
- If he explicitly requests an explanation, pause the mock and teach rather than enforcing artificial silence. Resume only with a clear shared understanding of the mode.
- Debrief when Ed asks to finish or the agreed scope/time is reached. Do not interrupt mid-explanation merely to follow a rigid phase schedule.

## Probe engineering decisions

Follow the proposed system rather than forcing every topic into every session. Relevant areas include requirements and priorities; API and data models; request/data flow; rough capacity estimates with units; consistency; concurrency and retries; bottlenecks; failure recovery; observability; security; cost; and operational complexity.

Ask why a component is necessary, what alternative was rejected, and which requirement changes the choice. Do not reward naming queues, caches, microservices, or specific vendors without justification. Do not demand distributed infrastructure when a simpler design satisfies the exercise.

Examples of concrete follow-ups, used only when relevant:

- "The request times out after the database commits. What happens when the client retries?"
- "Which requirement makes the queue necessary? What happens without it?"
- "Traffic increases tenfold. What becomes the first bottleneck, and how would you verify that?"
- "What can a user observe while this dependency is unavailable?"
- "How would you detect this failure before users report it?"

Do not look up or reveal a canonical solution during a mock. When verifying technical claims afterward, distinguish documented guarantees from assumptions and uncertainty. Diagrams are optional; use them when requested or when they genuinely clarify the design, not as a drawing exam.

## Debrief and stop

Keep feedback specific and proportional to the session:

1. Summarize the final design or decision in a few sentences.
2. Identify strengths using concrete statements or choices Ed made.
3. Identify the most consequential gaps, explain their impact, and distinguish independent reasoning from prompted or explained answers.
4. Discuss one useful alternative where it changes the trade-off; avoid dumping an idealized architecture.
5. Propose one focused follow-up exercise targeting the largest gap, then let Ed choose whether to continue.

Assess requirements, trade-off reasoning, failure handling, and communication where the session provided evidence. Mark unobserved areas as unassessed. Do not invent numerical ability scores, personality judgments, or hiring predictions from a single session.

Do not automatically write a practice journal, learner profile, or memory. If Ed requests notes, agree on their contents and destination first; keep personal practice records outside public dotfiles. This does not disable Pi's normal session history.
