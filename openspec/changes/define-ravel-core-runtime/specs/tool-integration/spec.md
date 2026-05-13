## ADDED Requirements

### Requirement: Tool registry
The runtime SHALL provide a registry for host-supplied tools with names, descriptions, JSON-compatible input schemas, and execution metadata.

#### Scenario: Host registers tools
- **WHEN** a host starts a session with available tools
- **THEN** the runtime validates and exposes those tool declarations to the model adapter

### Requirement: Tool invocation contract
The runtime SHALL represent each requested tool invocation with a stable call identifier, tool name, structured arguments, and associated session identifier.

#### Scenario: Model requests a tool
- **WHEN** the model adapter returns a normalized tool call
- **THEN** the runtime emits a tool-requested event with the call identifier, tool name, and arguments

### Requirement: Host permission hook
The runtime MUST call a host-controlled permission hook before executing or dispatching any tool invocation marked as requiring approval.

#### Scenario: Permission is denied
- **WHEN** the host permission hook denies a requested tool invocation
- **THEN** the runtime does not execute the tool and appends a denied tool result to the session

### Requirement: Tool results
The runtime SHALL accept structured tool results containing success, failure, cancellation, or denial outcomes and feed those results back into the agent loop.

#### Scenario: Tool succeeds
- **WHEN** a tool invocation completes successfully
- **THEN** the runtime emits a tool-completed event and includes the structured result in the next model request

#### Scenario: Tool fails
- **WHEN** a tool invocation returns an error
- **THEN** the runtime emits a tool-failed event and includes a structured failure result in the next model request
