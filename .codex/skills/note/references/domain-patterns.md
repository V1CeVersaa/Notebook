# Domain Coverage Reference

Use the relevant section when planning a new note or substantive addition. These questions help identify missing knowledge within the requested scope; they are not a required outline, sequence, or quota of examples. Keep the source's assumptions and boundaries, and omit categories that do not help explain this material. For narrative and worked examples, use [human-voice.md](human-voice.md); for formatting, use [notebook-style.md](notebook-style.md).

## Systems and Compilers

Explain the problem the design addresses, the mechanism it uses, and the costs or constraints that matter. Those constraints may concern correctness, interfaces, portability, hardware resources, or access patterns; do not invent a hardware motivation for every concept. Compare alternatives when the source or task calls for a decision, naming the conditions under which each tradeoff matters.

Concrete details should identify the relevant platform, architecture, ABI, version, or workload when behavior depends on them. Use source-supported parameters and measurements rather than supplying familiar numbers from another system.

For a compiler transformation, show its input and output representation and explain why the transformation preserves the required behavior. Pair code with transformed code when that makes the mechanism visible. Discuss limitations or invalid cases where they matter to understanding the transformation.

## Programming Languages and Libraries

Organize around what an operation means, the conditions under which it is valid, and how its behavior appears in a small example. For stateful APIs, explain changes to state, ownership, lifetime, or errors when relevant. Identify language or library versions for version-dependent behavior.

Use compact lists or tables for parallel interfaces, and prose for the mechanism behind them. A runnable example should illustrate the distinction being taught; do not turn an interface note into an unrelated application or a catalog of every available method.

## CS Theory and Algorithms

Make definitions and their quantifiers understandable before relying on them. State the theorem's assumptions and conclusion, and explain the proof idea so the reader can follow why each step is needed. Keep necessary proof details; choose visible or collapsible presentation according to the role of the proof and the series convention.

For algorithms, explain the invariant or central idea, the operations that maintain it, and why they give the claimed result. State complexity with its cost model and relevant case (worst-case, expected, or amortized). For amortized arguments, identify the accounting method and show the accounting needed to justify the bound. Add computational consequences only when they follow from the stated result.

## Math and Optimization

Identify the objects, domains, assumptions, and quantifiers. Connect definitions to their meaning and use; geometry or examples are useful when they explain a condition that symbols alone leave obscure. Follow the logical dependencies of the argument rather than forcing every section through the same definition–theorem–example sequence.

In derivations, explain consequential transformations and where assumptions are used. For optimization, distinguish a local approximation from a bound, a descent step from convergence of the whole iteration, and stationarity from global optimality. State which conclusion has actually been established. Include algorithmic consequences or pseudocode when they are part of the requested material, following local notation.

## AI and ML

Explain the problem setting, mathematical objects, training or inference mechanism, and the evidence supporting the main claims. For a proposed change, identify the baseline and what changes in the objective, computation, or data. Separate the authors' motivation from a demonstrated explanation of why the method works.

When reporting experiments, retain the relevant data, model, comparison, metric, and resource conditions. Include ablations or unsuccessful approaches when they clarify the result and the source reports them; do not infer an unreported cause of failure.

When evaluating a design, name its scope and supporting evidence. A single paper's result does not establish field-wide consensus. Claims about common practice need a model class, time frame, and sufficient evidence; no fixed vocabulary or mandatory verdict is required. Definitions and mechanism descriptions can stand without an opinion.

## LM, Alignment, and RL

Use the general ML guidance where relevant. Explain how data, objectives, feedback, sampling, and updates interact, including the inference or environment protocol that makes the method meaningful. Trace an algorithm's evolution when the changes help explain the current design; avoid a historical detour when it adds no understanding.

For system comparisons, keep pipeline stages and evaluation conditions identifiable. Engineering details such as memory use, generation/training scheduling, and communication belong in the main explanation when they determine feasibility or explain a result. Do not add infrastructure details merely to fill a template.

For RL and preference-learning claims, make the environment, feedback assumptions, baseline, evaluation budget, and uncertainty visible when they affect interpretation. Preserve reported failures and qualifications. Distinguish an observed outcome from an explanation of its cause, and a setting-specific result from a general claim.
