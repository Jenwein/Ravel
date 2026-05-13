## Why

Ravel needs a clear core contract before implementation so it can serve as a reusable AI capability layer for many future tool applications, not as a single chat product or one-off agent. Defining the runtime boundary now keeps the C++ native core embeddable, observable, and extensible before provider, tool, UI, or application-specific choices harden into the architecture.

## What Changes

- Define Ravel as a library-first native C++ agent runtime with optional process adapters.
- Introduce a session-oriented agent runtime contract for bounded agent turns, event streaming, cancellation, and result reporting.
- Introduce a provider-neutral model adapter contract for streaming model responses and tool-call exchange.
- Introduce a structured tool integration contract covering tool schemas, registration, execution, results, and host-controlled permissions.
- Introduce host embedding surfaces so future applications can use Ravel through a C++ API first, with stable protocol boundaries available for non-C++ hosts.
- Establish explicit non-goals: Ravel is not a chat UI, not a single LLM provider wrapper, not an autonomous daemon by default, and not a place to bake in every future application domain.

## Capabilities

### New Capabilities

- `agent-runtime`: Core session and turn lifecycle, event stream, execution limits, cancellation, and final result semantics.
- `model-adapter`: Provider-neutral model invocation, streaming response handling, tool-call extraction, and model error reporting.
- `tool-integration`: Tool schema, registry, invocation, result delivery, and host permission hooks.
- `host-embedding`: Library-first host API expectations plus stable process/protocol adapter boundaries for CLI, IPC, and future language bindings.
- `context-management`: Transcript, host-provided context resources, context assembly, and future compaction boundaries.

### Modified Capabilities

- None.

## Impact

- Adds initial OpenSpec requirements for Ravel's core runtime architecture.
- Guides future C++ project structure, public APIs, CLI/headless runner design, and integration boundaries.
- Does not add application code or choose a concrete LLM provider, UI framework, persistence backend, or MCP implementation.
