# Ravel 项目宪章

## 文档目的

本文档定义 Ravel 面向核心开发者的长期项目方向。

它不是实现计划、任务拆分、API 参考或发布路线图。它的作用是让后续架构设计、OpenSpec 变更、实现取舍和代码评审有共同判断标准。

当本文档与更低层的实现细节冲突时，应显式更新实现计划或更新本宪章，而不是绕开冲突继续开发。

## Ravel 是什么

Ravel 是一个通用 agent foundation。当前技术路线是 library-first native C++ agent runtime。

Ravel 的核心产品不是聊天界面、命令行助手、后台 daemon，也不是某个模型服务的 API 包装。Ravel 的核心产品是 `libravel_core`：一个可嵌入的 agent core，让宿主应用能够把可控、可观察、具备记忆和工具能力的 agent runtime 集成到自己的系统里。

宿主应用可以带入自己的工具、上下文、记忆存储、凭证、UI 和安全策略。Ravel 提供可复用的 session runtime、模型适配、工具调用、记忆系统、上下文装配、权限决策、诊断和事件流。

Ravel 的长期身份是通用 agent foundation。Native C++ embedding 是当前主要技术路线，不是项目最终边界。

## 为什么需要 Ravel

调用大语言模型并不等于构建 agent 系统。真正的 agent 应用需要一个 runtime 来协调模型调用、工具调用、记忆、上下文、权限、取消、错误和可观测性。

Ravel 的目标是把这层 runtime 做成可复用基础设施。

Ravel 需要解决的问题包括：

- 把模型响应推进为有边界、可检查的 session，而不是黑盒函数调用。
- 允许模型请求工具，同时防止工具脱离宿主控制直接执行。
- 把 transcript、memory、host context、tool declarations、runtime instructions 和 policy constraints 装配成模型请求。
- 支持不同模型 provider 和自定义 API，而不让 core 被某一家 API 形状绑死。
- 向宿主提供结构化事件，用于 UI 渲染、日志、审计、测试、取消和调试。
- 把 memory 和 context 当成 runtime 能力，而不是临时拼接的 prompt 文本。
- 让本地应用、开发者工具、自动化 runner 和未来语言绑定共享同一套 agent contract。

Ravel 应避免每个未来宿主都重新实现一套脆弱的 model-tool-context-memory loop。

## 北极星原则

### 可嵌入性优先

Ravel 首先是可嵌入 runtime。核心库必须适合放进宿主应用，由宿主控制生命周期、UI、线程模型、凭证、工具、记忆、上下文和策略。

如果某个设计削弱宿主对执行、观察或安全策略的控制，默认应谨慎对待。

### 宿主拥有最终策略权

宿主应用是敏感行为的最终权限来源。Ravel core 不能默认假设读写文件、调用工具、访问记忆、使用上下文资源、发起网络请求或修改应用状态是安全的。

Ravel 可以定义 policy hook、permission request、默认 adapter 和结构化 denial result，但不能静默批准含义依赖宿主环境的动作。

### Agent Runtime，而不是产品外壳

Ravel 提供 agent core，不由聊天 UI、终端 UI、后台 daemon、单一应用流程或某个产品外壳定义。

runner、CLI、IPC protocol、demo 和应用集成都应是 core 之上的 adapter。它们可以验证 runtime contract，但不能成为架构中心。

### Schema-first Runtime Contract

Ravel 的长期契约应通过 schema-shaped runtime object 表达，包括 session、event、model message、tool declaration、tool invocation、tool result、memory record、context resource、permission decision、diagnostic 和 final outcome。

现代 C++ API 是最佳本地嵌入体验。长期稳定边界应是共享的 schema/protocol 词汇，支撑 runner、IPC、JSONL、测试、回放和未来语言绑定。

### 事件流是公开契约

Agent 执行有大量关键中间状态。Ravel 必须通过类型化、有序 runtime event 暴露这些状态。

Event 不是 debug log。日志可以从事件派生，但日志不能替代事件作为集成契约。

### 模型边界保持 Provider-neutral

Ravel core 不能长得像某一家模型 API。OpenAI-compatible 服务、本地模型、自定义 HTTP API 和未来 provider 都应通过 model adapter 接入。

Provider-specific 行为应留在 adapter、adapter configuration、diagnostic metadata 或 extension field 中，不能作为 core model request/event contract 的隐含前提。

### Memory 是一等能力

Memory 是 agent foundation 的核心部分。Ravel 应把 memory 作为一等 runtime capability，具备明确的 record、scope、recall、write、delete、policy、provenance、freshness 和 context integration。

Ravel 不应把某一个 memory database、vector store、markdown layout 或同步系统硬编码为唯一实现。Memory storage 和 retrieval 必须 adapter-friendly。

### Context Engineering 是核心 runtime 工作

Ravel 不只是 prompt forwarder。它必须定义 context assembly 边界，把 transcript、working memory、recalled long-term memory、host context resources、tool declarations、runtime instructions 和 policy constraints 变成 provider-neutral model request。

Context budget、priority、compaction、summarization、retrieval、omission 和 visibility 都是 runtime 需要正视、可观察、可控制的问题。

### 工具属于宿主能力

Ravel core 定义工具契约，宿主应用拥有具体工具。

Core 应负责规范化 tool declaration、tool invocation、permission request、tool result、diagnostic、transcript recording 和 event。宿主决定有哪些工具、工具做什么、谁能用、需要什么凭证、如何控制副作用。

### 小核心，可替换边缘

Ravel core 应保持小、明确、可嵌入。凡是因宿主、provider、存储后端、UI、协议、部署或策略而变化的能力，都应放在 adapter 或 extension boundary 后面。

对于通用基础设施，应务实使用成熟 C++ 开源库提升质量、避免重复造轮子。但依赖不能反过来重塑 core 架构。

## 目标场景

Ravel 应被设计为通用 agent foundation，而不是单一产品 runtime。

### Native and Embedded Applications

桌面应用、IDE、工程工具、创作工具和其他 native software 可以把 Ravel 作为本地 agent runtime 嵌入。

这些宿主可能有复杂 UI、领域状态、私有数据和自定义权限模型。Ravel 必须让宿主保持控制权。

### Developer and Operator Tools

代码理解、构建测试、诊断、运维和本地自动化工具可以用 Ravel 协调 model call、tool call、context 和 task execution，而不必变成完整聊天产品。

### Domain-specific Agent Systems

科研、数据分析、设计、仿真、企业内部系统等领域应用可以把 Ravel 作为可复用 agent core，并接入自己的工具、记忆、上下文和策略。

### Headless Runner and Automation

Ravel 应支持通过 thin runner、JSONL 或 IPC 进行 headless execution。这些 adapter 可用于测试、脚本化、CI、调试、回放和非交互工作流。

### Future Server and Multi-language Hosts

Ravel 的核心概念应能超越直接 C++ embedding。未来 server deployment、C ABI、IPC transport 和语言绑定都应包裹同一套 schema-first runtime contract，而不是定义另一套 agent 语义。

## 非目标

非目标是防发散边界，不代表永远禁止相关 adapter、示例或未来集成。

Ravel 不是：

- Chat UI 或终端聊天产品。
- Claude Code 或其他现有 agent 产品的复刻。
- 单一 LLM provider wrapper。
- 低代码 agent 平台。
- Tool marketplace 或固定内置工具库。
- 固定 memory database、固定 RAG 系统或固定 vector store。
- Workflow/DAG-first 编排平台。
- 默认长期运行的 autonomous daemon。
- 绑定某个业务领域的产品外壳。
- 把所有宿主应用策略集中进 core 的大框架。

Ravel 可以提供 runner，但 runner 是 adapter。Ravel 可以提供默认 file memory adapter，但 memory 必须保持可替换。Ravel 可以支持 workflow-like pattern，但 workflow 不应定义 core runtime。Ravel 可以集成具体 provider，但 provider API 不能塑造 core 类型。

## 核心架构方向

Ravel 应围绕小型可嵌入 core 和可替换边缘组织。

```text
Host Application
  owns UI, app state, credentials, concrete tools, context, memory policy
        |
        v
libravel_core
  Agent Runtime
  Model Adapter Boundary
  Tool Integration Boundary
  Memory System Boundary
  Context Assembly / Compaction
  Runtime Event Stream
  Host Policy Hooks
  Schema / Protocol Objects
  Host Embedding API
        |
        v
Optional Adapters
  ravel-runner
  JSONL / IPC protocol
  provider adapters
  memory adapters
  future language bindings
```

### Agent Runtime

Agent runtime 管理 session。一个 session 拥有稳定标识符、请求数据、runtime limits、生命周期状态、transcript、event stream、cancellation surface、diagnostics 和 final outcome。

Runtime 协调 model-tool-memory-context loop。它应支持有界执行、取消、迭代上限、最终结果和结构化失败结果。

Ravel 的 agent 模型是 bounded session runtime。长期自主 agent、多 agent 系统、planning mode、reflection loop 和 workflow orchestration 可以构建在 session runtime 之上或旁边，但 core 首先必须提供受控 session contract。

### Model Adapter Boundary

Model adapter boundary 在 Ravel 的 provider-neutral model request/event object 与具体模型 API 之间翻译。

Core model concepts 应包括 message、tool declaration、generation parameter、streaming delta、tool call、finish reason、usage metadata、provider diagnostic 和 structured error。

Ravel 应通过 adapter configuration 支持自定义 API 配置，例如 base URL、API key、model name、headers、timeout、generation parameters 和 streaming behavior。低成本模型应能用于真实测试和调试，同时不让 core provider-specific。

### Tool Integration Boundary

Tool integration 定义模型如何请求外部世界中的动作。

Ravel 应定义 tool declaration、JSON-compatible input schema、execution metadata、invocation identifier、session association、permission request、tool result 和 tool event。

Runtime 应把 tool success、tool failure、tool denial 和 tool cancellation 都作为结构化结果处理，记录进 transcript，并允许后续 context assembly 使用。

### Memory System Boundary

Memory 是一等 runtime 方向，具体实现应 adapter-friendly。

Ravel 至少应区分这些 memory 层次：

- Session transcript：当前 session 中 user input、assistant output、model tool call、tool result、diagnostic 和 final outcome 的有序记录。
- Working memory：任务局部状态、计划、约束、中间发现和临时结论。
- Long-term memory：跨 session 保留的信息，例如用户偏好、项目背景、持久决策、外部引用和协作习惯。
- Retrieval context：为某次 model request 选择出的相关 memory 或外部知识。
- Memory policy：宿主控制什么可以保存、召回、修改、遗忘、同步或暴露给模型。

Ravel 应定义带有 type、scope、provenance、timestamp、freshness/confidence metadata、source 和 policy-relevant attributes 的 memory record。

具体 memory storage 可以是文件、数据库、向量索引、远程同步、宿主自有系统或插件提供。Runtime 应定义 memory 如何进入和离开 agent loop，而不强制某个后端。

### Context Assembly / Compaction

Context assembly 是从 runtime state 和 host-provided resources 生成 provider-neutral model request 的过程。

输入可以包括：

- Runtime instructions。
- User input。
- Session transcript。
- Working memory。
- Recalled long-term memory。
- Host context resources。
- Tool declarations。
- Tool results。
- Permission and policy constraints。
- Provider and model limits。

Context assembly 应同时产出 model request 和 assembly report。Assembly report 应让决策可观察：哪些资源被包含、哪些被省略、哪些被摘要、使用了多少预算、是否触发 compaction、哪些 policy constraint 影响结果。

Compaction、summarization、trimming 和 retrieval strategy 应可替换，但它们的边界和效果必须对宿主可见。

### Runtime Event Stream

Event stream 是公开契约。每个重要 runtime transition 或 decision 都应有 typed event。

Event 至少应覆盖：

- Session lifecycle。
- Model request preparation。
- Model streaming delta。
- Model finish 和 model error。
- Tool requested。
- Permission requested 和 permission decided。
- Tool completed、failed、denied 或 cancelled。
- Memory recalled、written、updated、deleted 或 rejected。
- Context assembly 和 compaction。
- Warning 和 diagnostic。
- Cancellation。
- Final result。

每个 event 应包含 session identifier、event type、monotonic sequence number、timestamp 和 typed payload。

### Host Policy Hooks

Host policy hook 让宿主控制敏感 runtime 行为。

Policy 应能管理 tool execution、memory access、memory write、context resource visibility、network access、credential use、external effect 和其他宿主定义风险。

Permission denial 不是异常崩溃路径。它是结构化 runtime result，应被 emit、record，并在 session 继续时提供给模型。

### Schema / Protocol Objects

以下对象应具备 schema-shaped、serializable 形态：

- `SessionRequest`
- `SessionId`
- `RuntimeLimits`
- `RuntimeEvent`
- `ModelRequest`
- `ModelMessage`
- `ModelResponseEvent`
- `ToolDeclaration`
- `ToolInvocation`
- `ToolResult`
- `MemoryRecord`
- `MemoryQuery`
- `MemoryRecallResult`
- `ContextResource`
- `ContextAssemblyReport`
- `PermissionRequest`
- `PermissionDecision`
- `Diagnostic`
- `FinalOutcome`

Schema vocabulary 应版本化，并被 C++ API、runner、protocol、test、record/replay tool 和未来 binding 共享。

### Host Embedding API

C++ host API 应允许应用创建 session、注册工具、提供 context resource、配置 model 和 memory adapter、订阅 event、响应 permission request、取消执行并检查 final outcome。

API 应对 C++ 开发者自然可用，同时保留底层 schema-first contract。

## 运行时契约

Ravel session 的高层契约如下：

```text
Host creates SessionRequest
        |
        v
Ravel creates session and emits session-started
        |
        v
Context assembly builds ModelRequest
        |
        v
Model adapter streams model events
        |
        v
Runtime emits model events
        |
        +-- if model requests a tool:
        |     runtime emits tool-requested
        |     runtime asks host policy when required
        |     host executes, denies, fails, or cancels
        |     runtime records ToolResult
        |     runtime continues the loop
        |
        +-- if memory is needed:
        |     runtime recalls or writes through memory interfaces
        |     runtime emits memory/context events
        |
        +-- if context exceeds budget:
        |     runtime invokes compaction or emits budget diagnostics
        |
        v
Session ends with completed, failed, cancelled, or limit-exceeded outcome
```

核心约束：

- 每个 session 有稳定 session identifier。
- 每个 event 在 session 内有单调递增 sequence number。
- Runtime cancellation 被接受后，不得继续调度新的 model 或 tool work。
- Tool failure、permission denial、model failure、memory failure、context budget failure 和 limit exhaustion 都是结构化 outcome。
- Transcript、memory、context resource、tool declaration、tool call 和 tool result 都可以影响后续 context assembly。
- 内部实现可以演进，但外部可见 schema 和 event semantics 必须有意识地版本化。

## 设计取舍

### Library-first over Process-first

Ravel 以 `libravel_core` 为中心，而不是以 daemon 或 CLI process 为中心。Process runner 对验证、测试、脚本化和非 C++ 宿主很有用，但必须保持为 core library 之上的 adapter。

### Schema-first over ABI-first

Ravel 不应一开始承诺跨编译器、跨平台、跨标准库实现的稳定 C++ ABI。这个成本高且过早。

长期稳定边界应是 schema/protocol compatibility。C++ API 可以围绕这些概念为 native host 提供符合 C++ 习惯的封装。

### Host-owned Policy over Core-owned Permissions

没有宿主上下文，Ravel 无法判断某个 tool call 的真实风险。读文件、编辑文档、查询数据库、发送消息或写入 memory，在不同宿主里可能完全不同。

因此 host policy 必须是最终权限来源。

### Provider-neutral over Provider-shaped Core

围绕某一个 provider 硬编码 core 类型会让早期 demo 更简单，但会伤害长期集成。Ravel 应只规范 runtime 需要的语义，并把 provider-specific 细节保存在 adapter diagnostic 或 metadata 中。

### Event Stream over Return-only API

Return-only API 会隐藏 agent 系统真正困难的部分：tool decision、memory recall、context assembly、permission check、streaming model output、warning 和 cancellation。

Ravel 应把这些过程暴露为结构化 event。

### Memory as Core Capability over Prompt-only Context

Memory 不能只是 prompt 里的额外文本。Ravel 需要 memory record、recall、write、policy、provenance、freshness 和 context integration 作为 runtime 方向的一部分。

### Replaceable Memory Backend over Fixed Memory Database

不同宿主需要不同 memory storage 和 retrieval model。Ravel 可以提供默认 adapter，但不能要求所有宿主都使用同一个数据库、文件结构、vector store 或同步机制。

### Context Assembly Boundary over Ad Hoc Prompt Building

Context assembly 必须是独立边界，因为它决定模型能看到什么。把 prompt construction 藏在 provider adapter 里，会让预算、隐私、召回和省略决策难以测试和解释。

### Tool Contract over Built-in Tool Platform

Ravel 不应变成 tool marketplace 或固定工具平台。宿主拥有具体工具。Ravel 拥有让工具使用变得可控、可观察、可重复的契约。

### Small Core over All-in-one Framework

Ravel 应避免变成大型应用框架。Core 定义稳定概念和 runtime coordination。Provider integration、memory store、observability backend、protocol adapter 和 UI behavior 都应保持为可替换边缘。

## 参考项目

仓库中的 `docs/vendor/` 是研究输入，不是项目源代码。

### Hello-Agents

Hello-Agents 有助于理解 agent 概念和经典范式。它提供的启发包括：

- Agent loop：perception、reasoning、action、observation。
- ReAct：model-tool-observation loop。
- Plan-and-Solve：先显式规划，再执行。
- Reflection：执行、批判、改进。
- Tool、memory、context 和 termination condition 是 agent 工程核心。

Ravel 应借鉴这些范式，但不应变成教学框架或 Python tutorial runtime。

### Claude Code

Claude Code 可作为 production agent harness 的参考。它说明真实 agent 工具需要：

- Tool permission。
- Runtime event 和 UI-visible progress。
- Session transcript 和 resume。
- 多层 memory。
- Context compaction。
- Tool execution normalization。
- Protocol 和 runner boundary。
- Diagnostic 和 policy control。

它的 memory 设计尤其值得借鉴：memory 不是单一功能，而可能包含 instruction file、session transcript、long-term memory file、session summary、relevant recall 和 background extraction。

Ravel 不应复制 Claude Code 的产品形态。Claude Code 是 CLI agent product，有自己的 UI、provider assumption、internal service、feature flag 和 product-specific policy。Ravel 是 embeddable runtime foundation。

## 开发判断准则

当判断某个 feature、API、dependency 或 design 是否属于 Ravel core 时，使用以下规则：

1. 如果某个设计让宿主更难控制 lifecycle、permission、context、memory、tool 或 UI，拒绝它或把它移到 adapter 后面。
2. 如果某个 API 只能服务一个 model provider，把 provider-specific 行为推入 model adapter。
3. 如果某个概念需要长期兼容性，先定义 schema，再依赖 C++ 实现细节。
4. 如果行为属于具体应用领域，把它放在 host、adapter、plugin 或 example 层。
5. 如果依赖会把重型 storage、UI、network、provider SDK、telemetry 或 daemon 假设带入 core，必须有强理由或隔离它。
6. 如果 runtime state 影响 host UX、auditability、safety、testing 或 replay，把它暴露为 event，而不只是 log。
7. 如果 model、tool、memory、context 或 policy 工作失败，产出 structured diagnostic 或 outcome。
8. 如果 context assembly 改变模型行为，让该决策可观察。
9. 如果 memory 被召回或写入，保留 type、source、policy、freshness 和 provenance 语义。
10. 如果默认实现有用，把它作为可替换支持提供，而不是唯一实现。
11. 如果抽象只服务假想未来，不要引入；如果它保护已经确认的边界，可以有意识地引入。
12. 对通用基础设施，优先使用成熟 C++ 库提升质量；但不能让依赖定义 Ravel 架构。

## 如何使用本文档

用本宪章判断方向，不要用它替代 OpenSpec proposal、design、capability spec、task list、测试或 API 文档。

新增能力仍应通过 OpenSpec 或其他明确设计流程捕获后再实现。实现阶段、发布里程碑、API 签名、依赖锁定和测试计划应从本宪章派生，而不是直接塞进本文档。

如果实现工作证明本宪章中的判断是错的，应更新宪章并记录新的决策理由。过期宪章比没有宪章更危险，因为它会让架构漂移看起来像有意为之。
