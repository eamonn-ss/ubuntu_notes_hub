# Architecture Decision Records

Use one ADR per durable technical decision.

Naming:

```text
ADR-0001-short-title.md
ADR-0002-short-title.md
```

Create new ADRs by copying:

```text
.ai/templates/ADR-0000-template.md
```

Do not keep `*-template.md` files in this directory.

Accepted ADRs:

| ADR | Title | Status |
|---|---|---|
| [ADR-0001](ADR-0001-organize-notes-by-topic.md) | Organize notes by topic under `md/` | Accepted |
| [ADR-0002](ADR-0002-note-filename-convention.md) | Content-based kebab-case note filenames | Accepted |
| [ADR-0003](ADR-0003-note-metadata-header.md) | Note metadata header (`环境` / `验证`) | Accepted |

Status values:

- Proposed
- Accepted
- Superseded
- Rejected
- Deprecated

Create an ADR when a decision affects future contributors, for example:

- architecture;
- public interfaces;
- persistence formats;
- external dependencies;
- model/algorithm selection;
- deployment strategy;
- compatibility guarantees.

Do not create ADRs for:

- trivial implementation details;
- temporary debugging choices;
- every code edit.

When a decision changes, prefer marking the previous ADR `Superseded` and linking the new ADR rather than rewriting history.
