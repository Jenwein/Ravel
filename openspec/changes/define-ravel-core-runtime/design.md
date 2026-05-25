## Context

Ravel is starting from an empty product surface with only project-level intent: a native C++ agent foundation for future tool applications. Those future hosts may include CLIs, desktop tools, IDE extensions, servers, or domain-specific applications, so the core cannot assume a single UI, application state model, LLM provider, or tool ecosystem.

The core architectural constraint is reuse. Ravel must expose a stable agent runtime that host applications can embed, observe, constrain, and extend. Vendor references in `docs/vendor` are useful as architecture research, but Ravel should not copy a chat product, a TypeScript runtime, or a tutorial framework as its shape.

## Goals / Non-Goals

**Goals:**

- Define Ravel as a library-first native C++ runtime.
- Preserve an embeddable core with clean boundaries around model providers, tool execution, context assembly, and host policy decisions.
- Make agent sessions observable through structured events instead of hidden internal state.
- Support a thin headless process adapter for CLI, IPC, protocol testing, and non-C++ host integration.
- Keep first-version requirements focused on the reusable runtime contract rather than a specific application.

**Non-Goals:**

- Build a chat UI or user-facing product shell.
- Choose a final LLM provider, persistence backend, UI framework, or MCP implementation.
- Start with an autonomous background daemon.
- Encode future application domains directly into the core runtime.
- Promise a stable C++ ABI across compilers as the only integration boundary.

## Decisions

### Decision: Library-first core with optional process adapters

Ravel will center on `libravel_core` as the primary product artifact. A thin `ravel-runner` or `ravel-cli` can exercise the library and expose a structured protocol, but the process wrapper is an adapter rather than the architecture center.

Alternatives considered:
- Process-first daemon: easier for polyglot hosts, but prematurely commits to lifecycle, IPC, and background ownership before the core contract is stable.
- App-first CLI/chat product: useful for demos, but risks shaping Ravel around one user experience instead of reusable infrastructure.

### Decision: Stable schemas before stable ABI

The modern C++ API will be the best in-process developer experience, but long-lived integration contracts will be expressed as stable schemas: session requests, runtime events, tool schemas, model messages, and result objects. A C ABI and JSONL/IPC protocol can wrap those schemas for non-C++ consumers.

Alternatives considered:
- C++ API only: simpler initially, but brittle for language bindings and cross-compiler use.
- JSON-only core: easier for external integrations, but weakens the native C++ embedding goal.

### Decision: Host-owned policy and application state

Ravel will ask the host to provide tools, context resources, policy hooks, and persistence decisions. The core can enforce runtime limits and call host hooks, but it will not silently approve sensitive tool calls or own application-specific state.

Alternatives considered:
- Core-owned permissions: simpler for standalone use, but unsafe for embedded applications where the host understands the user, workspace, and domain.
- Tool-only trust model: fast to build, but makes future safety and observability difficult.

### Decision: Event-streamed runtime

Agent execution will be reported through typed events: lifecycle transitions, model deltas, tool-call requests, tool results, warnings, errors, cancellation, and final output. Hosts can render, log, audit, test, or interrupt sessions without depending on internal implementation details.

Alternatives considered:
- Return-only API: easiest API surface, but too opaque for tool applications that need progress, approvals, or debugging.
- Log-based observability: useful as a supplement, but not a reliable integration contract.

### Decision: Provider-neutral model boundary

The model layer will translate between Ravel's internal request/response structures and concrete provider APIs. Tool-call extraction, streaming deltas, errors, and usage metadata will be normalized at the adapter boundary.

Alternatives considered:
- Hard-code one provider first: faster, but encourages provider details to leak into core runtime APIs.
- Full plugin system first: flexible, but too much mechanism before the first runtime contract exists.

### Decision: Initial third-party stack

Ravel's first implementation will use an intentionally modern, personal-project-friendly C++ stack:

- C++23 as the language baseline.
- Premake 5 as the primary build/project generation tool.
- GoogleTest and GoogleMock for tests.
- `nlohmann/json` for JSON values, schema-like data, event serialization, and JSONL protocol messages.
- libcurl for HTTP/HTTPS client transport, including provider API calls and streaming-capable integrations.
- OpenSSL for HTTPS/TLS support where required by libcurl and other HTTP integrations.
- CLI11 for the thin runner command-line interface.
- spdlog for runtime and runner logging.
- stduuid as a small utility dependency for UUID/session identifiers, unless implementation proves a simpler local identifier is sufficient.

Explicitly deferred dependencies:
- fmt as a direct dependency; C++23 `std::format` is preferred initially unless spdlog usage makes fmt unavoidable.
- `yhirose/cpp-httplib`; libcurl is the initial HTTP client choice, and an embedded HTTP server should only be added when a concrete runner or IPC need requires one.
- Boost; avoid it unless a later capability needs a specific Boost component.
- SQLite; defer until durable session, transcript, or memory storage is in scope.
- OpenTelemetry C++; defer until structured traces and metrics are needed.
- simdjson; defer until JSON parsing throughput becomes a demonstrated bottleneck.
- JSON Schema validation libraries; defer until tool schema validation needs exceed basic structural checks.

## Risks / Trade-offs

- Library-first development may delay standalone demos -> Keep a thin runner in scope for verification and protocol testing.
- Stable schemas require upfront discipline -> Keep schemas small, versioned, and directly tied to runtime events and tool contracts.
- Host-owned policy makes sample usage more verbose -> Provide safe default policy hooks in examples later without moving ownership into core.
- Provider neutrality can over-abstract real provider behavior -> Normalize only required runtime semantics and preserve provider diagnostics in structured metadata.
- Multiple capabilities in the first change can grow large -> Treat this change as contract definition, not full implementation of every future subsystem.
- Premake is less standard than CMake for downstream package consumption -> Treat Premake as the first project build system and defer install/package consumer workflows.
- libcurl is a C API and may need a small C++ wrapper -> Keep the wrapper local to transport/model-adapter code so libcurl details do not leak into core runtime contracts.

## Migration Plan

There is no existing Ravel runtime to migrate. Implementation can begin by scaffolding `libravel_core`, adding a runner only after the core request/event contracts are testable.

## Open Questions

- Which first provider adapter should be used for end-to-end verification?
- Should the first process adapter use JSONL over stdio, local sockets, or both?
- Which persistence boundary belongs in the first implementation: transcript-only, session snapshots, or no durable storage?
