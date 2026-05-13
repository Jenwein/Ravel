## ADDED Requirements

### Requirement: Library-first API
Ravel SHALL expose the core runtime as an embeddable native C++ library API for creating sessions, registering tools, providing context, subscribing to events, and cancelling execution.

#### Scenario: Host embeds Ravel
- **WHEN** a C++ host application links the core library
- **THEN** it can create and run an agent session without launching a separate daemon

### Requirement: Stable protocol boundary
Ravel SHALL define stable schema-based request, event, tool, and result structures that can be reused by optional process adapters and future language bindings.

#### Scenario: Non-C++ host uses an adapter
- **WHEN** a non-C++ host communicates with a Ravel runner through a supported protocol
- **THEN** the exchanged messages use the same session, event, tool, and result schemas as the core runtime

### Requirement: Thin runner
Any CLI or headless runner SHALL remain a thin adapter over the core library and MUST NOT own behavior that belongs to the core runtime contract.

#### Scenario: Runner executes a session
- **WHEN** the runner receives a valid session request
- **THEN** it delegates execution to the core runtime and streams core runtime events to the caller

### Requirement: UI independence
The core runtime SHALL NOT depend on a chat UI, terminal UI, desktop UI, or application-specific interaction model.

#### Scenario: Host renders events differently
- **WHEN** two different host applications consume the same runtime event stream
- **THEN** each host can render or handle the events without changing core runtime behavior
