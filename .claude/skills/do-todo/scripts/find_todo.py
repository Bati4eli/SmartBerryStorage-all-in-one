import re
import sys
from pathlib import Path


TODO_ID_RE = r"\d{3}(?:(?:\.\d+)|(?:-[a-z0-9]+))*"
TODO_RE = re.compile(rf"^\* \[([ xX!])\] `(?P<id>{TODO_ID_RE})` (?P<title>.+)$")

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")
if hasattr(sys.stderr, "reconfigure"):
    sys.stderr.reconfigure(encoding="utf-8")


def usage() -> int:
    print("Usage: find_todo.py <workspace-root> <todo-id>", file=sys.stderr)
    return 2


def main() -> int:
    if len(sys.argv) != 3:
        return usage()

    workspace_root = Path(sys.argv[1])
    todo_id = sys.argv[2]
    if not re.fullmatch(TODO_ID_RE, todo_id):
        print("TODO id must use 000, 000.0, or 000-name format, example: 090-map-filter", file=sys.stderr)
        return 2

    todo_files = (
        workspace_root / "MyCloud-AndroidClient" / "DO-TODO-backlog.md",
        workspace_root / "MyCloud-AndroidClient" / "DO-TODO-done.md",
    )
    for todo_file in todo_files:
        if not todo_file.exists():
            print(f"TODO file not found: {todo_file}", file=sys.stderr)
            continue

        lines = todo_file.read_text(encoding="utf-8").splitlines()
        for index, line in enumerate(lines):
            match = TODO_RE.match(line)
            if not match or match.group("id") != todo_id:
                continue

            details = []
            for extra in lines[index + 1:]:
                if TODO_RE.match(extra) or extra.startswith("## "):
                    break
                if extra.strip():
                    details.append(extra)

            print(f"id: {todo_id}")
            print(f"file: {todo_file}")
            print(f"line: {index + 1}")
            status = {"x": "done", "!": "blocked"}.get(match.group(1).lower(), "open")
            print(f"status: {status}")
            print(f"title: {match.group('title')}")
            if details:
                print("details:")
                for detail in details:
                    print(detail)
            return 0

    print(f"TODO {todo_id} not found in backlog or done files", file=sys.stderr)
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
