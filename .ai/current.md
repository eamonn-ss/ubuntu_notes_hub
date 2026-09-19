# Current Project State

> This is the short-lived global state. Keep it concise and overwrite stale information.

**Last updated:** 2026-09-19

## Current Objective

Maintain discoverable, trustworthy notes: kebab-case names, metadata headers, and accurate indexes. Long-note TOC deferred.

## Active Task

None (TASK-003 Done)

## Current Status

- ADR-0001 / 0002 / 0003 accepted
- Filenames normalized; metadata on all notes; thin notes polished; PDF cross-links + `.cursorignore`
- Long-note TOC intentionally not done

## Current Blockers

- None

## Recent Verified Findings

- `验证：未复核…` used everywhere for this editorial pass (no machine re-run claimed)
- `check-context.sh --strict` passes

## Working Tree Notes

Recommended commit buckets if committing later:

1. Note renames + `md/README.md` + PDF/shell renames
2. Note metadata / thin-note polish / typo fixes
3. `.ai/` + `AGENTS.md` + `scripts/` + `.cursor*` context system
4. `md/ue_a2f/facegood-metahuman-dataset-rebuild.md` (and any ACE content edits) separately

## Next Action

Await user direction (commit, long-note TOC later, or new note work).

## Do Not Accidentally Change

- Layered context protocol in `AGENTS.md`
- Honest `验证` semantics (do not mark verified without re-running steps)
- Long UE/PICO notes structure unless user asks for TOC/split
