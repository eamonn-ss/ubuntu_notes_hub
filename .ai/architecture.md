# Current Architecture

> Describe the architecture as it exists now. Historical architecture belongs in ADRs or Git history.

## System Overview

```text
Human / Agent session
   ↓
AGENTS.md (protocol)
   ↓
.ai/index.md → current.md + relevant stable docs
   ↓
Edit / add notes under md/<domain>/
   (optional: pdf/, shell/)
   ↓
Git history as durable fact trail
```

This repository is a **notes hub**, not an application. The main artifact is topic-organized Markdown. The `.ai/` tree is an agent-facing overlay so sessions can restore intent without re-exploring the whole tree.

## Major Components

### `md/` — primary knowledge store

Responsibilities:

- Hold runbooks, install guides, command cheatsheets, and troubleshooting notes
- Group by domain directory (see `.ai/context.md` domain map)

Must not:

- Become an unstructured dump at repo root
- Silently duplicate large vendor manuals when a short local delta note would suffice

### `pdf/` — static references

Responsibilities:

- Store PDF knowledge dumps that are not meant to be edited as Markdown

### `shell/` — executable snippets

Responsibilities:

- Keep standalone install/fix scripts referenced by notes (e.g. OpenCV)

### `AGENTS.md` + `.ai/` — agent memory overlay

Responsibilities:

- Protocol, stable facts, architecture, decisions, tasks, handoffs, changelog

Must not:

- Duplicate full note content
- Mix file templates into `tasks/`, `decisions/`, or `handoffs/`

### `scripts/check-context.sh`

Responsibilities:

- Verify required context files exist
- Warn on stray templates and bootstrap placeholders
- Support `--strict` for CI-style failure on warnings

### `.cursor/rules/ai-context.mdc`

Responsibilities:

- Remind Cursor agents to follow `AGENTS.md` before non-trivial work

## Repository Map

```text
.
├── AGENTS.md
├── README.md
├── LICENSE                 # MIT
├── .cursor/rules/ai-context.mdc
├── .cursorignore.example
├── scripts/
│   └── check-context.sh
├── shell/                  # OpenCV install / fix snippets
├── pdf/                    # Static PDF references
├── md/                     # Topic Markdown notes (+ README.md index)
│   ├── docker/
│   ├── frame_transform/
│   ├── git/
│   ├── linux_system/
│   ├── mujoco/
│   ├── mvs/
│   ├── others/
│   ├── pico_unity/
│   ├── plc/
│   ├── ros2/
│   ├── ue_a2f/
│   └── yolo/
└── .ai/
    ├── index.md
    ├── context.md
    ├── architecture.md
    ├── current.md
    ├── changelog.md
    ├── decisions/
    ├── tasks/
    ├── handoffs/
    ├── templates/
    └── archive/
```

## Data Flow

1. New agent session reads `AGENTS.md` → `.ai/index.md` → `.ai/current.md`.
2. For note work, open the matching `md/<domain>/` files (and ADRs if organization rules matter).
3. Verify Git status before editing; preserve unrelated uncommitted work.
4. After meaningful sessions, update task / `current.md` / changelog / handoff as needed.

## Important Interfaces

### Agent note-editing contract

Input:

```text
User asks to add / fix / extend a technical note
```

Output:

```text
Updated Markdown under the correct md/<domain>/ path, with verified or clearly marked unverified steps
```

Contract:

- Prefer existing domain folders over inventing new top-level trees
- Do not invent install paths or CLI flags; prefer copying from existing notes or marking assumptions
- Keep `.ai/context.md` domain map in sync when adding a lasting new topic folder

### Context health check

Input:

```text
./scripts/check-context.sh
./scripts/check-context.sh --strict
```

Output:

```text
[OK]/[MISS]/[WARN] lines; non-zero exit on missing required files (and on warnings in --strict)
```

## Dependency Rules

- Notes may reference external tools (ROS 2, Docker, UE, etc.) but must not assume those tools are installed in this repo.
- Agents may depend on `.ai/` documents and Git state.
- Context documents must not invent facts that contradict the notes or Git history.
- Active registries (`tasks/`, `decisions/`, `handoffs/`) must not depend on chat-only claims.

## Configuration

| Configuration | Location | Notes |
|---|---|---|
| Agent protocol | `AGENTS.md` | Canonical entry |
| Cursor reminder | `.cursor/rules/ai-context.mdc` | `alwaysApply: true` |
| Ignore example | `.cursorignore.example` | Rename after review if needed |

## Validation / Test Entry Points

```bash
./scripts/check-context.sh
./scripts/check-context.sh --strict
bash -n scripts/check-context.sh
```

There is no application test suite; validation for notes is editorial (commands tried on the author's machine) plus context-script checks.

## Known Architectural Risks

- Domain map in `.ai/context.md` can drift if new `md/*` folders are added without updating it
- Very large notes (especially UE / PICO guides) increase token cost if agents read whole files unnecessarily — prefer targeted section edits
- Uncommitted note work and context-system bootstrap can collide in the same working tree; always check `git status` first
- Template leftover language in `.ai/` historically misled agents into treating this repo as a meta-template project
