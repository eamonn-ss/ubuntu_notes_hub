# TASK-002: Normalize note filenames from content

**Status:** Done  
**Priority:** P1  
**Created:** `2026-09-19`  
**Updated:** `2026-09-19`

## Goal

Rename notes/PDFs/shell snippets to kebab-case names that match each file's actual topic, add a `md/README.md` index, and record the naming rule as an ADR.

## Why

Filenames mixed Chinese, spaces, typos, and misleading names, which hurt discovery for humans and agents.

## Scope

- Explore note contents and rename under `md/`, `pdf/`, `shell/`
- Delete empty stub `md/mujoco/mujoco_install_note.md`
- Add ADR-0002 naming convention
- Add `md/README.md` domain index
- Update root README / `.ai` status docs

## Out of Scope

- Rewriting note body content
- Splitting long UE/PICO documents
- Committing unless requested

## Relevant Files

- `md/**`
- `pdf/**`
- `shell/**`
- `.ai/decisions/ADR-0002-note-filename-convention.md`
- `md/README.md`

## Dependencies

- ADR-0001 (topic folders under `md/`)

## Acceptance Criteria

- [x] Filenames are kebab-case ASCII (no spaces)
- [x] Names reflect document topics verified from content
- [x] `md/README.md` lists current files with one-line descriptions
- [x] Empty mujoco stub removed
- [x] `./scripts/check-context.sh` still passes

## Plan

1. Inventory content → rename map
2. ADR + renames
3. Index + context updates
4. Validate

## Work Log

### `2026-09-19`

- Extracted headings/summaries from all Markdown notes
- Applied content-based renames across `md/`, `pdf/`, `shell/`
- Added ADR-0002 and `md/README.md`
- Removed empty `mujoco_install_note.md`

## Verified Results

- `./scripts/check-context.sh --strict` exit 0
- All 33 note files referenced from `md/README.md`
- No spaced filenames under `md/`, `pdf/`, `shell/`

## Open Questions / Risks

- External bookmarks to old paths will break
- `facegood-metahuman-dataset-rebuild.md` remains untracked (was never committed under old name)

## Next Action

None for this task. Optionally commit rename + index + ADR when the user requests.
