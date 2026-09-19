# Current Project State

> This is the short-lived global state. Keep it concise and overwrite stale information.

**Last updated:** 2026-09-19

## Current Objective

Maintain discoverable, trustworthy notes: kebab-case names, metadata headers, and accurate indexes. Long-note TOC deferred.

## Active Task

None

## Current Status

- ADR-0001 / 0002 / 0003 accepted
- Filenames normalized; metadata on all notes; thin notes polished; PDF cross-links + `.cursorignore`
- Committed in buckets: renames → note polish → AI context → FACEGOOD guide (as separate commits)
- Long-note TOC intentionally not done

## Current Blockers

- None

## Recent Verified Findings

- `验证：未复核…` used for the editorial pass (no machine re-run claimed)
- `check-context.sh --strict` passes

## Working Tree Notes

- Prefer not to mark notes `验证` with a real date unless steps were re-run

## Next Action

Optional: push to origin, or later add TOC/split for long UE/PICO notes.

## Do Not Accidentally Change

- Layered context protocol in `AGENTS.md`
- Honest `验证` semantics (do not mark verified without re-running steps)
- Long UE/PICO notes structure unless user asks for TOC/split
