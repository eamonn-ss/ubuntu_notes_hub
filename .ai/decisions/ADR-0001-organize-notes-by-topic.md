# ADR-0001: Organize notes by topic under md/

**Status:** Accepted  
**Date:** `2026-09-19`  
**Supersedes:** `N/A`  
**Superseded by:** `N/A`

## Context

This repository accumulates install guides, runbooks, and troubleshooting notes across Linux, robotics, vision, simulation, and Unreal/ACE workflows. Without a durable layout rule, agents and humans tend to drop files at the repo root or invent parallel trees, which makes discovery and cross-session editing unreliable.

## Decision

1. Put editable knowledge in `md/<domain>/<note>.md`.
2. Create a new `md/<domain>/` directory when a lasting topic does not fit an existing domain.
3. Keep static PDFs in `pdf/` and standalone shell snippets in `shell/`.
4. Keep agent memory (protocol, tasks, ADRs, handoffs) in `.ai/` / `AGENTS.md`, not mixed into note domains.
5. When adding a lasting new domain folder, update the domain map in `.ai/context.md`.

## Alternatives Considered

### Option A — Flat `md/` with no subfolders

Pros:

- Fewer directories

Cons:

- Harder navigation as note count grows
- Poor agent targeting for scoped edits

### Option B — One note tree per tool vendor at repo root

Pros:

- Familiar for some monorepos

Cons:

- Pollutes root next to LICENSE / scripts / `.ai/`
- Conflicts with the agent-context overlay layout

### Option C — Topic folders under `md/` (chosen)

Pros:

- Clear discovery path
- Matches existing repository content
- Easy for agents to scope reads

Cons:

- Requires occasional domain-map maintenance in `.ai/context.md`

## Rationale

The repository already follows topic folders under `md/`. Codifying that layout prevents bootstrap/template language and ad-hoc paths from undoing a working convention.

## Consequences

### Positive

- Agents can restore context and jump to the correct folder quickly
- New notes have an obvious home
- `.ai/` remains thin and navigable

### Negative

- Borderline topics may need a judgment call (`others/` vs a new domain)
- Domain map can drift if not updated

## Compatibility / Migration Impact

- No file moves required for adoption; existing `md/*` layout already complies
- Future notes should not be added at repository root

## Validation

- New notes land under an existing or intentionally new `md/<domain>/`
- `./scripts/check-context.sh` remains green after context updates
- `.ai/context.md` domain map matches `ls md/`
