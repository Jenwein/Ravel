## ADDED Requirements

### Requirement: Session lifecycle
The runtime SHALL manage each agent execution as a session with a stable session identifier, host-provided request data, lifecycle state, and final outcome.

#### Scenario: Session starts
- **WHEN** a host starts an agent session with a valid request
- **THEN** the runtime emits a session-started event containing the session identifier and initial lifecycle state

#### Scenario: Session completes
- **WHEN** the agent loop reaches a final assistant result
- **THEN** the runtime records the session as completed and emits a final-result event

### Requirement: Bounded agent loop
The runtime SHALL execute agent turns through a bounded loop that alternates model calls, optional tool requests, tool results, and final output until completion or a configured limit is reached.

#### Scenario: Tool call continues the loop
- **WHEN** a model response contains a tool call
- **THEN** the runtime routes the call through tool integration and continues the session with the tool result

#### Scenario: Iteration limit stops the loop
- **WHEN** the configured maximum iteration count is reached before final output
- **THEN** the runtime stops the session and emits a limit-exceeded error event

### Requirement: Ordered runtime events
The runtime SHALL expose ordered, typed events for session lifecycle, model activity, tool activity, warnings, errors, cancellation, and final output.

#### Scenario: Events are ordered
- **WHEN** a host consumes events from a running session
- **THEN** each event includes the session identifier, event type, and monotonically increasing sequence number

### Requirement: Cancellation
The runtime SHALL allow the host to request cancellation of an active session and MUST stop scheduling additional model or tool work after cancellation is accepted.

#### Scenario: Host cancels a session
- **WHEN** the host cancels an active session
- **THEN** the runtime emits a cancellation event and returns a cancelled final outcome
