# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository state

Ravel is **spec-first, pre-code**. No C++ build, source, or tests are committed yet. All work to date lives as OpenSpec artifacts and a project charter. Read those before proposing or writing code — they are the source of truth for what Ravel is, what it is not, and what gets built next.

- `docs/project-charter.md` — long-term direction for Ravel as a *library-first native C++ agent foundation*. The whole charter is load-bearing; do not work around it without updating it.
- `openspec/changes/define-ravel-core-runtime/` — the active change that will define the first runtime contract. Contains `proposal.md`, `design.md`, `tasks.md`, and capability specs under `specs/{agent-runtime,model-adapter,tool-integration,context-management,host-embedding}/spec.md`.
- `AGENTS.md` — contributor-facing repo conventions (commits, PRs, style).
- `docs/vendor/` — third-party reference material (Hello-Agents, Claude Code). Treat as research input only; do not copy code or product shape into Ravel. This directory and `.claude/` / `.codex/` are gitignored.

## Commands

OpenSpec is the only tool used today (CLI installed globally as `openspec`, currently v1.3.1):

- `openspec list` — show active changes and task progress.
- `openspec validate define-ravel-core-runtime --strict` — required verification step before claiming spec work is ready.
- `openspec status --change <name> --json` and `openspec instructions apply --change <name> --json` — used by the `/opsx:*` slash commands to drive the apply/archive workflow.

No C++ build scaffold exists. When tasks under section 1 of `define-ravel-core-runtime/tasks.md` land, the planned stack is Premake 5 + C++23 + GoogleTest with dependencies on nlohmann/json, libcurl, OpenSSL, CLI11, spdlog, and stduuid. Document the exact generate/build/test invocations here once they exist.

## Architecture (planned)

The charter defines a small core with replaceable edges. Future source must respect these boundaries — do not collapse them for convenience:

```
Host Application  (owns UI, app state, credentials, concrete tools, context, memory policy)
        ↓
libravel_core
  ├── Agent Runtime          — bounded sessions, lifecycle, cancellation, final outcome
  ├── Model Adapter Boundary — provider-neutral request/event objects, streaming, tool-call extraction
  ├── Tool Integration       — tool declarations, invocations, permission requests, structured results
  ├── Memory System          — session transcript, working memory, long-term memory, retrieval, policy
  ├── Context Assembly       — transcript + memory + host resources + tools → model request + assembly report
  ├── Runtime Event Stream   — typed, ordered events; the public integration contract
  ├── Host Policy Hooks      — host has final authority on sensitive actions
  ├── Schema / Protocol Objects — versioned, serializable; shared across C++ API, runner, IPC, tests
  └── Host Embedding API     — C++-natural surface over the schema contract
        ↓
Optional Adapters: ravel-runner, JSONL/IPC, provider adapters, memory adapters, future language bindings
```

### Non-negotiable principles (from the charter)

These are stable judgment rules. When in doubt, apply them before adding code or APIs:

- **Host-owned policy.** Core never silently approves tool execution, file/network access, or memory writes. Permission denial is a structured runtime result, not an exception.
- **Provider-neutral core.** Model-provider details live behind the model-adapter boundary. Do not let an OpenAI/Anthropic/etc. API shape leak into core types.
- **Schema-first, not ABI-first.** Long-lived contracts are schema/protocol objects (session, event, model message, tool, memory record, permission, diagnostic, outcome). The C++ API wraps the schemas; do not commit to a cross-compiler stable C++ ABI.
- **Events are the public contract.** Every significant runtime transition is a typed, ordered event with a monotonic sequence number — not just a log line.
- **Memory and context assembly are first-class.** Not prompt-string concatenation. Memory records carry type/scope/provenance/freshness; context assembly produces both a `ModelRequest` and an observable assembly report.
- **Small core, replaceable edges.** Anything that varies by host, provider, storage, UI, protocol, or deployment goes behind an adapter. Mature C++ libraries are welcome for plumbing, but dependencies must not reshape core types.

### Things Ravel is explicitly **not**

Do not propose features that turn Ravel into any of these (see charter §"非目标" for the full list):

- A chat UI, terminal chat product, or Claude Code clone.
- A single-LLM-provider wrapper.
- A long-running autonomous daemon by default.
- A fixed memory database, fixed RAG, or fixed vector store.
- A workflow/DAG orchestration platform or low-code agent builder.
- A tool marketplace or framework that bakes in domain-specific tools.

## Working in this repo

- **Stay scoped to the active OpenSpec change.** Don't introduce code, specs, or capabilities outside what the current change covers. If implementation reveals the spec is wrong, update the spec rather than drift the code.
- **Run `openspec validate <change> --strict` after editing any spec, design, task, or proposal file.** It's the only executable verification step until C++ tests exist.
- **Capability spec directories use concise kebab-case names** (`agent-runtime`, `tool-integration`, `context-management`, `model-adapter`, `host-embedding`). Change names also kebab-case (e.g., `define-ravel-core-runtime`).
- **C++23 when code lands.** Prefer small explicit types for session IDs, events, tool calls, model messages, and diagnostics. Keep provider-specific code in adapters and host-specific policy out of core.
- **Commits**: concise imperative; an optional bracketed scope like `[ADD]` is acceptable. PRs should link the relevant OpenSpec change/task and list verification commands run.
- **Do not copy from `docs/vendor/`.** Use it to inform decisions only; Ravel stays native and independently designed.

## Slash commands available

The `.claude/commands/opsx/` directory wires `/opsx:explore`, `/opsx:propose`, `/opsx:apply`, and `/opsx:archive` to the OpenSpec experimental workflow. Use these (or the corresponding `openspec-*` skills) when the user wants to move a change through propose → apply → archive.
