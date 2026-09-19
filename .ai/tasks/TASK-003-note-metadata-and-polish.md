# TASK-003: Note metadata, thin-note polish, PDF links

**Status:** Done  
**Priority:** P2  
**Created:** `2026-09-19`  
**Updated:** `2026-09-19`

## Goal

Add honest metadata headers, strengthen thin notes, cross-link PDFs, fix obvious typos, and add `.cursorignore` — without adding TOC to long notes.

## Scope

- ADR-0003 metadata convention
- Metadata on `md/**/*.md` (except index) and `shell/*.md`
- Strengthen thin notes; fix typos
- PDF cross-links in `md/README.md`
- `.cursorignore` for large PDFs

## Out of Scope

- Long-note TOC / splitting
- Committing
- Claiming machine re-verification dates

## Acceptance Criteria

- [x] ADR-0003 accepted
- [x] Notes have `> 环境：` metadata
- [x] Thin notes improved or clearly cross-linked
- [x] PDF index linked from `md/README.md`
- [x] `./scripts/check-context.sh --strict` passes

## Work Log

### `2026-09-19`

- Added ADR-0003 and metadata to all notes + shell troubleshooting md
- Strengthened thin notes; fixed typos; PDF cross-links; `.cursorignore`

## Verified Results

- Meta coverage: all `md/**/*.md` except README + `shell/*.md`
- Typo scan clean for `docerk` / `nujoco` / `pyhton`
- `./scripts/check-context.sh --strict` exit 0

## Next Action

None. Optionally commit in recommended buckets when requested.
