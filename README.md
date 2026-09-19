# ubuntu_notes_hub

Personal technical notes for Ubuntu / Linux, robotics, vision, simulation, and related tooling.

## Layout

| Path | Contents |
|---|---|
| [`md/`](md/README.md) | Editable Markdown runbooks (see domain index) |
| `pdf/` | Static PDF references |
| `shell/` | Standalone install / fix scripts and notes |
| `.ai/` + `AGENTS.md` | AI agent context (protocol, tasks, ADRs) |
| `scripts/check-context.sh` | Validates the `.ai/` context tree |

Filenames use content-based kebab-case ([ADR-0002](.ai/decisions/ADR-0002-note-filename-convention.md)).
Each note carries `环境` / `验证` metadata ([ADR-0003](.ai/decisions/ADR-0003-note-metadata-header.md)).

## Agent context

```bash
./scripts/check-context.sh
./scripts/check-context.sh --strict
```

Before non-trivial agent work, follow `AGENTS.md` and start from `.ai/index.md` / `.ai/current.md`.

## License

MIT — see `LICENSE`.
