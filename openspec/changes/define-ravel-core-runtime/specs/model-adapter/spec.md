## ADDED Requirements

### Requirement: Provider-neutral model request
The model layer SHALL accept provider-neutral model requests containing messages, tool declarations, generation parameters, and runtime metadata.

#### Scenario: Runtime invokes a provider
- **WHEN** the agent runtime needs a model response
- **THEN** it submits a provider-neutral request through the configured model adapter

### Requirement: Streaming model responses
The model adapter SHALL normalize streaming provider output into typed response events consumable by the runtime and host.

#### Scenario: Provider streams text
- **WHEN** a provider emits partial assistant text
- **THEN** the model adapter converts it into ordered model-delta events

### Requirement: Tool-call extraction
The model adapter SHALL normalize provider-specific tool-call representations into Ravel tool-call objects with stable call identifiers, tool names, and structured arguments.

#### Scenario: Provider returns a tool call
- **WHEN** a provider response requests tool execution
- **THEN** the model adapter returns a normalized tool-call object to the runtime

### Requirement: Model diagnostics
The model adapter SHALL report provider errors, refusal states, usage metadata, and finish reasons without leaking provider-specific control flow into the runtime.

#### Scenario: Provider request fails
- **WHEN** a provider request fails
- **THEN** the model adapter returns a structured model-error result containing retryability and provider diagnostic metadata
