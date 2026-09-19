# ADR-0003: Note metadata header

**Status:** Accepted  
**Date:** `2026-09-19`  
**Supersedes:** `N/A`  
**Superseded by:** `N/A`

## Context

Many notes omit environment and freshness signals. Months later it is unclear whether commands still apply (Ubuntu release, UE/ROS versions, etc.).

## Decision

1. Every editable note under `md/**/*.md` (except `md/README.md`) starts with an H1, then a short metadata blockquote:

```markdown
# Title

> 环境：…
> 验证：未复核 | YYYY-MM-DD（说明）
> 相关：optional relative links
```

2. `验证` must be honest:
   - `未复核` when only editorial/repo work happened
   - a real date only when the author re-ran the steps on a machine
3. Prefer concrete environment tokens when known (`Ubuntu 22.04`, `UE 5.6.x`, `ROS 2`, `MuJoCo 210`); otherwise `通用` / `未注明`.
4. Shell troubleshooting prose under `shell/*.md` follows the same header pattern.
5. Do not invent versions that are not implied by the note body.

## Alternatives Considered

### Option A — YAML front matter

Pros: machine-parseable  
Cons: noisier for a personal Chinese-first notes hub

### Option B — Blockquote metadata after H1 (chosen)

Pros: readable in GitHub/IDE preview; low ceremony  
Cons: slightly less structured for tooling

## Rationale

The goal is trust calibration (“can I follow this today?”), not a CMS. A two-line blockquote is enough.

## Consequences

### Positive

- Agents and humans can skim freshness before executing commands

### Negative

- Existing notes need a one-time pass; metadata can drift if not updated after real verification

## Compatibility / Migration Impact

- Additive only; no filename or folder changes

## Validation

- Notes (except `md/README.md`) contain `> 环境：` near the top
- `验证` does not claim machine verification unless true
