# ADR-0002: Note filename convention (content-based kebab-case)

**Status:** Accepted  
**Date:** `2026-09-19`  
**Supersedes:** `N/A`  
**Superseded by:** `N/A`

## Context

Notes under `md/`, plus `pdf/` and `shell/`, used inconsistent names: Chinese titles, spaces, ambiguous abbreviations (`git_p`), and names that contradict content (`ssh_connect_failed` was VS Code Server download failure). Agents and shell tooling struggle with spaces and misleading paths.

## Decision

1. Prefer **ASCII kebab-case** filenames: `lowercase-words-with-hyphens.ext`.
2. Name files from **document topic** (primary heading / purpose), not from how the file was created.
3. Keep the domain folder for taxonomy; the filename should still be understandable alone.
4. Avoid spaces, underscores-as-primary-separator, and redundant `tutorial` spam unless it distinguishes purpose.
5. Shell scripts use `.sh`; troubleshooting prose under `shell/` should become `.md` (or move into `md/`).
6. When renaming, update `md/README.md` (and `.ai/context.md` only if domain folders change).

## Alternatives Considered

### Option A — Keep Chinese filenames matching H1 titles

Pros:

- Matches reader language

Cons:

- Awkward in terminals, URLs, and some tooling
- Harder for ASCII-centric agent path matching

### Option B — Content-based kebab-case ASCII (chosen)

Pros:

- Stable paths for Git/scripts/agents
- Forces names to describe content

Cons:

- English names for Chinese-body notes require a short index description

## Rationale

This is a personal engineering notes hub consumed by both humans and AI agents. Path stability and semantic accuracy matter more than mirroring the H1 language exactly; `md/README.md` can carry Chinese one-line descriptions.

## Consequences

### Positive

- Clearer discovery and fewer misleading opens
- Safer scripting / linking

### Negative

- One-time rename churn; any external bookmarks to old paths break

## Compatibility / Migration Impact

- Historical Git history retains old names; use `git log --follow` when needed
- Update indexes in the same change set as renames

## Validation

- No spaces in `md/`, `pdf/`, `shell/` filenames
- `md/README.md` descriptions match file contents
- `./scripts/check-context.sh` remains green
