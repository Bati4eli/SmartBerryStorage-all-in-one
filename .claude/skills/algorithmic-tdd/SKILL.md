---
name: algorithmic-tdd
description: "Build or fix algorithmic and business logic with tests, explicit invariants, counterexamples, and evidence. Use when correctness, edge cases, state transitions, or data integrity matter; not for style-only edits."
---

# Algorithmic TDD

Use this workflow before changing production logic when an incorrect result,
lost data, an invalid state transition, or an unhandled boundary case would
matter. Do not turn a style-only change into a TDD exercise.

## Establish the behavioral contract

Before implementing, state the following in the task output or a short plan:

- Inputs and outputs, including ownership and mutation expectations.
- Valid and invalid input domains, error behavior, ordering, and ties.
- State transitions and side effects, if any.
- The invariants that must remain true for every permitted input.
- Explicit non-goals or unknown product rules that could change the result.

Use a decision table when behavior depends on several conditions. Ask the user
only when a missing product rule makes two materially different outcomes valid;
do not silently choose one.

## Derive the tests before code

Turn each user-visible behavior and invariant into an executable test. Start
with the highest-risk path, then select the relevant adversarial cases:

- empty, singleton, minimum, maximum, duplicate, and boundary values;
- malformed or absent input and expected failure behavior;
- ordering, ties, idempotency, and repeated calls;
- transitions from every allowed prior state and attempts at forbidden ones;
- mutation/aliasing, integer or time boundaries, and external failures when
  the code handles them.

For pure algorithms, add property-based or fuzz tests when practical: assert
the invariant rather than only a few examples. For stateful code, use
integration tests that exercise real persistence or a faithful boundary.

Write a focused test that fails for the intended missing or faulty behavior,
run it, and record the RED result. A test that merely exists, fails from broken
setup, or does not exercise the changed path is not evidence.

## Implement and prove the change

Make the smallest implementation that makes the relevant tests GREEN. Do not
weaken assertions or update expected values solely to match an incorrect
implementation. Re-run the same test target, then the appropriate broader
suite, type check, and lint/build checks available in the project.

Review the final diff as an adversary:

- try to construct a counterexample for every important invariant;
- trace callers and error handling instead of judging a function in isolation;
- check that tests verify observable behavior, not only implementation details;
- look for off-by-one errors, omitted branches, stale state, mutation, and
  assumptions that types or existing validation do not actually enforce.

For consequential changes, perform this review from a fresh context or by an
independent reviewer when the environment supports it.

## Report evidence and limits

Finish with a concise table of guarantees: behavior or invariant, test that
proves it, and result. Name untested paths, unavailable environments, and
unresolved product rules plainly. Passing tests establish only the guarantees
they cover; never claim an algorithm is defect-free without a suitable proof.
