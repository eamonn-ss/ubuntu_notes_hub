# Semantic Changelog

> Git records exact diffs. This file records why meaningful changes mattered.

## Unreleased

### Added

- ADR-0001: organize editable notes under `md/<domain>/`
- ADR-0002: content-based kebab-case filenames for notes / pdf / shell
- ADR-0003: note metadata header (`环境` / `验证`)
- TASK-001: adopt AI context for ubuntu_notes_hub
- TASK-002: normalize note filenames from content
- TASK-003: metadata, thin-note polish, PDF links
- Project-specific `.ai/context.md` / `.ai/architecture.md` content for this notes hub
- `md/README.md` domain index with one-line Chinese summaries + PDF cross-links
- `.cursorignore` excluding `pdf/` from default Cursor context
- Minimal root `README.md` describing the repository purpose and layout

### Changed

- Replaced template-repo framing ("AI Project Context Template") with ubuntu_notes_hub facts
- Renamed notes/PDFs/shell files to match verified document topics
- Strengthened thin notes (`docker-commit`, point-cloud, proxy-pip, frame-drop, apt-mirror)
- Fixed typos: Docker H1 `docerk`→`Docker`, mujoco `~/.nujoco`→`~/.mujoco`, snap7 code fences

### Fixed

- Agents no longer receive stale instructions implying this repo's primary goal is maintaining a reusable context template
- Removed empty stub `md/mujoco/mujoco_install_note.md`
- Corrected typo path `pdf/cuda_windowns.pdf` → `pdf/cuda-windows.pdf`
- Corrected broken `https_proxy` example in proxy/pip note

### Learned

- After copying a context template into a real notes repo, stable docs must be rewritten immediately or every new session will restore the wrong project identity
- Filename truth must come from note headings/body; historical names often describe the symptom or a wrong guess
- Metadata `验证` must stay honest (`未复核`) unless steps were re-run on a machine

### Removed

## 2026-08-11 (template bootstrap, historical)

### Added

- `.ai/` skeleton, `AGENTS.md`, Cursor rule, and `scripts/check-context.sh` (template-era)

### Learned

- File-existence checks alone are insufficient; placeholder and stray-template warnings catch adoption footguns
