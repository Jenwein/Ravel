## 1. Project Scaffold

- [ ] 1.1 Add a Premake 5 workspace for `libravel_core`, `ravel-runner`, and GoogleTest-based tests.
- [ ] 1.2 Configure the project for C++23 and the initial dependency set: GoogleTest/GoogleMock, nlohmann/json, cpp-httplib, OpenSSL, CLI11, spdlog, and stduuid.
- [ ] 1.3 Add source and include directory layout for runtime, model, tools, context, host API, and protocol schemas.
- [ ] 1.4 Add a first GoogleTest target that can compile and run without network access or real model providers.

## 2. Core Schemas and Events

- [ ] 2.1 Define session request, session identifier, lifecycle state, final outcome, and runtime limit types.
- [ ] 2.2 Define ordered runtime event types for lifecycle, model, tool, warning, error, cancellation, and final result events.
- [ ] 2.3 Add event sequencing so each emitted event includes a session identifier and monotonic sequence number.
- [ ] 2.4 Add structured error and diagnostic types for runtime, model, tool, permission, and context failures.

## 3. Agent Runtime

- [ ] 3.1 Implement session creation and session-started event emission.
- [ ] 3.2 Implement the bounded agent loop with model calls, tool-call handling, tool-result feedback, and final-result completion.
- [ ] 3.3 Enforce maximum iteration limits and emit a limit-exceeded error outcome.
- [ ] 3.4 Implement host cancellation and prevent additional model or tool work after cancellation.
- [ ] 3.5 Add unit tests for lifecycle completion, tool-call loop continuation, iteration-limit stop, ordered events, and cancellation.

## 4. Model Adapter and Context

- [ ] 4.1 Define the provider-neutral model adapter interface for model requests, streaming deltas, tool calls, finish reasons, usage metadata, and errors.
- [ ] 4.2 Implement a deterministic fake model adapter for local runtime tests.
- [ ] 4.3 Define transcript entries for user input, assistant output, tool calls, and tool results.
- [ ] 4.4 Implement context assembly from transcript, host context resources, runtime instructions, and tool declarations.
- [ ] 4.5 Add context budget handling that emits a context-budget event or calls a configured compaction boundary.
- [ ] 4.6 Add tests for model delta normalization, tool-call extraction, model error diagnostics, transcript recording, and context assembly.

## 5. Tool Integration and Policy

- [ ] 5.1 Define tool declaration types with name, description, JSON-compatible input schema, and execution metadata.
- [ ] 5.2 Implement tool registry validation and exposure to the model adapter.
- [ ] 5.3 Implement normalized tool invocation objects with call identifier, tool name, arguments, and session identifier.
- [ ] 5.4 Implement host permission hooks before approved-required tool execution or dispatch.
- [ ] 5.5 Implement structured tool results for success, failure, cancellation, and denial.
- [ ] 5.6 Add tests for registration, invocation events, permission denial, successful result feedback, and failed result feedback.

## 6. Host Embedding and Runner

- [ ] 6.1 Expose a minimal C++ host API for creating sessions, registering tools, providing context, subscribing to events, and cancelling sessions.
- [ ] 6.2 Define schema-based request, event, tool, and result serialization for optional process adapters.
- [ ] 6.3 Implement a thin `ravel-runner` that delegates session execution to `libravel_core` and streams runtime events.
- [ ] 6.4 Add tests proving the runner uses the same schemas and core behavior as the in-process C++ API.

## 7. Verification and Documentation

- [ ] 7.1 Add a README section describing Ravel's library-first architecture and non-goals.
- [ ] 7.2 Add a README or developer note documenting the selected C++23/Premake third-party stack and deferred dependencies.
- [ ] 7.3 Add developer documentation for the runtime event stream, tool contract, model adapter contract, and host policy hook.
- [ ] 7.4 Run formatting, compile, GoogleTest suite, and OpenSpec validation for this change.
