# Project Context

> Stable facts only. Do not put daily progress here.

## Project

**Name:** ubuntu_notes_hub

**One-line description:**

Personal technical notes hub: Markdown runbooks, install guides, and troubleshooting notes for Linux, robotics, vision, simulation, and related tooling — plus a lightweight AI agent context layer under `.ai/`.

## Primary Goal

Keep durable, searchable engineering notes organized by topic, and give AI agents enough repository memory to edit those notes safely across sessions without relying on chat history.

## Users / Runtime Environment

- Primary author / consumer: repository owner (eamon)
- Secondary consumers: AI coding agents (Cursor and similar) editing or drafting notes
- Deployment: local Git workspace; remote `origin` at `git@github.com:eamonn-ss/ubuntu_notes_hub.git`
- OS focus: Ubuntu / Linux workflows (notes also cover Windows UE tooling where relevant)
- Language/runtime: Markdown notes + Bash helper scripts; no application server

## Core Technology

- Topic-grouped Markdown under `md/`
- Optional PDF references under `pdf/`
- Shell install/fix snippets under `shell/`
- Agent protocol: `AGENTS.md` + `.ai/` context tree
- Optional Cursor rule: `.cursor/rules/ai-context.mdc`
- Context health check: `scripts/check-context.sh`

## Hard Constraints

1. Notes are the product; `.ai/` is supporting memory for agents, not a second notes tree.
2. Prefer verified commands and paths from the notes / Git history over chat recollection.
3. Do not require agents to read every file under `.ai/` or every note — navigate from `.ai/index.md` and the relevant `md/<topic>/` folder.
4. Never treat `*-template.md` under `.ai/templates/` as active tasks, ADRs, or handoffs.
5. Large binary/PDF additions should stay intentional; prefer Markdown for editable knowledge.
6. Editable notes under `md/` carry an honest metadata blockquote (`环境` / `验证`) per ADR-0003.

## Non-Goals

- Not a packaged application, library, or CI-driven product
- Not a second copy of upstream vendor docs (notes should capture local deltas, pitfalls, and verified workflows)
- Not a mandate to rewrite historical notes into a uniform style on every edit

## Domain Terms

| Term | Meaning |
|---|---|
| Note domain | A topic folder under `md/` (e.g. `md/ros2/`, `md/ue_a2f/`) |
| Runbook | Step-by-step operational / install / troubleshooting note |
| ADR | Architecture Decision Record in `.ai/decisions/` |
| Active task | Execution-state file in `.ai/tasks/` (not a template) |
| Handoff | Cross-session snapshot in `.ai/handoffs/` |
| A2F / ACE | NVIDIA Audio2Face-3D / ACE Unreal Plugin workflows documented under `md/ue_a2f/` |

## Note Domains (stable map)

| Path | Topic |
|---|---|
| `md/linux_system/` | Ubuntu install, network, apt, systemd, SSH, NVIDIA container toolkit |
| `md/docker/` | Docker install, build networking, image edits |
| `md/git/` | Git usage notes |
| `md/ros2/` | ROS 2 packages, commands, XML, distributed comms |
| `md/frame_transform/` | DH parameters, point clouds / frames |
| `md/mujoco/` | MuJoCo install and usage |
| `md/mvs/` | Machine-vision / MVS tutorial notes |
| `md/yolo/` | YOLO tutorial notes |
| `md/plc/` | PLC / Snap7 |
| `md/pico_unity/` | PICO / Unity Linux install and pose publisher |
| `md/ue_a2f/` | Unreal + NVIDIA ACE Audio2Face / MetaHuman data acquisition |
| `md/others/` | Catch-all (Python, ONNX, queue lag, etc.) |
| `pdf/` | Static PDF references |
| `shell/` | Standalone shell snippets (e.g. OpenCV install / fix) |

## External Systems

| System | Purpose | Interface |
|---|---|---|
| GitHub (`eamonn-ss/ubuntu_notes_hub`) | Remote backup / share | `git` remote `origin` |
| Cursor / other agents | Edit notes using `.ai/` memory | File reads / rules |
| Upstream tools documented in notes | ROS 2, Docker, UE, MuJoCo, etc. | As described per note |

## Known Invariants

Things agents should assume unless explicitly changed:

- Source-of-truth priority is defined in `AGENTS.md`
- Editable knowledge lives primarily under `md/`
- File templates live only under `.ai/templates/`
- `current.md` is overwritten with latest state; `changelog.md` is append-only
- New note topics get a new `md/<topic>/` directory rather than dumping into repo root
