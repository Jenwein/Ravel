## ADDED Requirements

### Requirement: Transcript model
The runtime SHALL maintain a structured transcript of user inputs, assistant outputs, model tool calls, and tool results for each session.

#### Scenario: Tool result is recorded
- **WHEN** a tool invocation returns a result
- **THEN** the runtime records the tool result in the session transcript with its matching tool-call identifier

### Requirement: Host-provided context resources
The runtime SHALL accept host-provided context resources as structured inputs with identifiers, content type metadata, and scope.

#### Scenario: Host provides context
- **WHEN** a host starts a session with context resources
- **THEN** the runtime makes those resources available to context assembly without assuming application-specific storage

### Requirement: Context assembly boundary
The runtime SHALL assemble model context from the transcript, host-provided resources, available tool declarations, and runtime instructions through a dedicated context assembly step.

#### Scenario: Model request is prepared
- **WHEN** the runtime prepares a model request
- **THEN** context assembly produces the provider-neutral message set passed to the model adapter

### Requirement: Compaction boundary
The runtime SHALL keep context compaction as an explicit replaceable boundary and MUST NOT require a specific compaction algorithm in the initial core contract.

#### Scenario: Context exceeds configured budget
- **WHEN** assembled context exceeds the configured budget
- **THEN** the runtime emits a context-budget event or invokes a configured compaction strategy before calling the model adapter
