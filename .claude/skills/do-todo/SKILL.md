---
name: do-todo
description: Execute SmartBerryStorage TODO items from the Android project backlog. Use when the user writes commands like "do 001", "do 090-map-filter", "сделай 003", or asks to start a TODO.
---

# Do TODO

## Workflow

1. Parse the requested TODO id from the user message. IDs start with three digits and may have numeric or hyphenated suffixes, for example `001.0`, `106.2`, or `090-map-filter`.
2. Run `python .claude/skills/do-todo/scripts/find_todo.py <workspace-root> <id>` from the workspace root to locate the item in `SmartCloud-Android/DO-TODO-backlog.md`. Do not start a task found only in `DO-TODO-done.md`. Never read or use `README.md` as a TODO source.
3. State the TODO id and its concise human-readable summary at the start of the work so the session is easy to identify.
4. Read root `AGENTS.md` and local repo `AGENTS.md` files before changing code (they are also imported via `CLAUDE.md`).
5. Determine affected repositories from the TODO text:
   - `android`: work in `SmartCloud-Android`.
   - `backend`: work in `SmartCloud-Backend-apps`.
   - `android&backend`, `back`, or mixed notes: inspect and update both repos when the contract requires it.
6. Check `git status --short` separately in every affected repo.
7. Implement the TODO end to end, keeping changes scoped to that numbered task.
8. Convert every requirement line and sub-bullet in the TODO into a verification checklist before marking the task complete. Keep the checklist in the working notes and check every item explicitly after implementation; do not treat compilation alone as proof of behavior.
9. Add unit tests for every new feature and for changed behavior. Run the relevant unit-test suite and record the result. If a requirement cannot reasonably be unit-tested, document the reason and cover it with the strongest available verification instead.
10. Perform self-checks proportionate to the changed TODO and affected repository:
   - Backend: run the relevant build and tests. Deploy and manually check the change when the TODO changes a running backend flow or the user requests deployment.
   - Android/client/frontend: validate the changed flows on an emulator or connected device through ADB (path to `adb.exe` is fixed in `SmartCloud-Android/AGENTS.md`). At minimum, build/install the target, drive the flow, inspect the UI tree, and capture relevant logs/screenshots or explain why a step is not applicable.
   - Android: also run at least `:app:compileDebugJavaWithJavac` when code changes.
   - Record unrelated failures from the shared suite, but do not let them block a completed TODO.
11. As soon as the TODO requirements are implemented and task-specific verification passes, mark the item `[x]`, then move its complete source block from `DO-TODO-backlog.md` to `DO-TODO-done.md`.
   - Copy every line of the task block 1:1: title, indentation, blank lines, lists, code blocks, links, and wording.
   - Change only the checkbox from `[ ]` or `[!]` to `[x]`.
   - Do not summarize, paraphrase, reformat, shorten, expand, replace, or add implementation results to the archived task text.
12. Report in Russian by TODO id, affected repo, changed files, compatibility impact, and archival to `DO-TODO-done.md`. Include the complete requirement checklist with one `пройдено`/`не пройдено`/`не применимо` result and evidence for every item, plus unit-test and self-check results.

## Rules

- Do not renumber unrelated TODO items while executing a task.
- `DO-TODO-backlog.md` contains open (`[ ]`) and blocked (`[!]`) items. `DO-TODO-done.md` contains only completed (`[x]`) items.
- Never read, modify, or use `README.md` for TODO work. Add open items only to `DO-TODO-backlog.md`; archive completed items only to `DO-TODO-done.md`.
- If the TODO changes API/DTO/protobuf/gRPC behavior, inspect both backend and Android client before finalizing.
- New features must include unit-test coverage; do not archive a feature with untested new behavior unless the exception and replacement verification are documented.
- Do not archive a TODO only while one of its own requirements is unresolved or task-specific verification fails. Unrelated failures in the shared suite are reported but do not delay archival.
- If the TODO is ambiguous, first inspect code and existing docs; ask the user only when implementation choice changes behavior or scope materially.
- Do not commit unless the user explicitly asks for commit.
- If a TODO introduces new methods specifically for that feature, mark those methods in JavaDoc using the exact line format `* DoneForToDo ###:` with the current TODO id.
- If the user asks to commit a TODO-driven change, include only the numeric part of the TODO id in the commit subject right after the label; preserve a numeric decimal suffix such as `.0`, but omit a hyphenated text suffix. Keep the rest of the message consistent with the target repo AGENTS rules, and do not wrap the subject or TODO number in quotes, for example `feat: #100 📷 ...` for `100-autoupload` or `feat: #001.0 🗺️ ...`.
- Write every user-visible status update, clarification, and final task result in Russian.

## Script

Use:

```powershell
python C:\MY_PROJECTS\SmartBerryStorage-all-in-one\.claude\skills\do-todo\scripts\find_todo.py C:\MY_PROJECTS\SmartBerryStorage-all-in-one 090-map-filter
```
