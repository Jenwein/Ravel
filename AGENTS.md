# Repository Guidelines

## Project Structure & Module Organization

Ravel is currently a spec-first repository for a library-first native C++ agent runtime. The root `README.md` is intentionally minimal. Active requirements live under `openspec/changes/define-ravel-core-runtime/`, with `proposal.md`, `design.md`, `tasks.md`, and capability specs in `specs/*/spec.md`.

`docs/vendor/` contains external reference material and examples. Treat it as research input, not project source. Local agent/tool state under `.claude/` and `.codex/` is ignored by git.

The planned implementation should add a C++23 Premake workspace for `libravel_core`, a thin `ravel-runner`, and GoogleTest-based tests. Keep future source organized by runtime, model adapter, tool integration, context management, host API, and protocol/schema boundaries.

## Build, Test, and Development Commands

- `openspec list`: show active changes and task progress.
- `openspec validate define-ravel-core-runtime --strict`: validate the current core-runtime change before editing specs or claiming readiness.

No C++ build scaffold is committed yet. When it lands, document the exact Premake generation, build, formatting, and GoogleTest commands here and in `README.md`.

## Coding Style & Naming Conventions

Use C++23 for implementation work. Prefer small, explicit types around session IDs, events, tool calls, model messages, and diagnostics. Keep provider-specific details behind model adapters and host-specific policy outside the core runtime.

Use clear kebab-case for OpenSpec change names, as in `define-ravel-core-runtime`. Use concise, capability-oriented spec directories such as `agent-runtime`, `tool-integration`, and `context-management`.

## Testing Guidelines

The planned test stack is GoogleTest and GoogleMock. Add tests with the feature they verify, and cover lifecycle completion, ordered events, cancellation, iteration limits, tool results, permission denial, context assembly, and model adapter normalization.

Until executable tests exist, OpenSpec validation is the required verification step for spec changes.

## Commit & Pull Request Guidelines

Recent history uses short messages such as `Initial commit` and `[ADD]init docs`. Prefer concise imperative commits; an optional bracketed scope like `[ADD]` is acceptable if it improves scanability.

Pull requests should describe the change, link the relevant OpenSpec change or task, list verification commands run, and call out any deferred implementation or test coverage. Include screenshots only for future UI-facing work.

## Agent-Specific Instructions

Keep changes scoped to the active OpenSpec task. Do not copy architecture or code wholesale from `docs/vendor/`; use vendor material only to inform decisions that remain native to Ravel.
