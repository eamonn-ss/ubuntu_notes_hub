# TASK-001: Adopt AI context for ubuntu_notes_hub

**Status:** Done  
**Priority:** P1  
**Created:** `2026-09-19`  
**Updated:** `2026-09-19`

## Goal

Replace template-oriented `.ai/` facts with accurate project context for this notes hub so future agent sessions restore the real repository purpose and layout.

## Why

`.ai/current.md` and related docs still described an "AI Project Context Template", which conflicts with the actual content under `md/`, `pdf/`, and `shell/`.

## Scope

- Rewrite `.ai/context.md`, `.ai/architecture.md`, `.ai/current.md`
- Add ADR for note organization
- Update `.ai/changelog.md` and a minimal `README.md`
- Validate with `scripts/check-context.sh`

## Out of Scope

- Rewriting or reformatting existing technical notes under `md/`
- Committing or pushing (unless explicitly requested)
- Adding `init-ai-context.sh` (not present in this working tree)

## Relevant Files

- `.ai/context.md`
- `.ai/architecture.md`
- `.ai/current.md`
- `.ai/changelog.md`
- `.ai/decisions/ADR-0001-organize-notes-by-topic.md`
- `.ai/tasks/TASK-001-adopt-ai-context.md`
- `README.md`
- `scripts/check-context.sh`

## Dependencies

- None

## Acceptance Criteria

- [x] Stable context describes ubuntu_notes_hub as a notes hub, not a meta-template
- [x] Architecture map matches current directories (`md/`, `pdf/`, `shell/`, `.ai/`, `scripts/`)
- [x] Domain map lists current `md/*` folders
- [x] ADR-0001 accepted for topic layout
- [x] `./scripts/check-context.sh` exits 0
- [x] `./scripts/check-context.sh --strict` exits 0

## Plan

1. Inventory repository content and compare against template `.ai/` text
2. Rewrite stable + active context docs
3. Record ADR and task state
4. Run context check scripts

## Work Log

### `2026-09-19`

- Inventoried `md/` domains (12 topic folders), `pdf/`, `shell/`, and context scripts
- Confirmed template language in `.ai/context.md` / `architecture.md` / `current.md` was stale
- Rewrote project context and architecture for the notes hub
- Added ADR-0001 for `md/<domain>/` organization
- Updated README / index / decisions registry; validation scripts passed

## Verified Results

- `./scripts/check-context.sh` exit 0
- `./scripts/check-context.sh --strict` exit 0

## Open Questions / Risks

- Working tree still has unrelated uncommitted note edits under `md/ue_a2f/`
- Earlier snapshot mentioned `md/interview/`; that folder is not present now

## Next Action

None for this task. Optionally commit context-system files when the user requests.
