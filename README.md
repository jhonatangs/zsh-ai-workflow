# ⚡ Zsh AI Workflow Plugin

A parameterized CLI router for Zsh designed to orchestrate autonomous AI agents directly from your terminal. 

This plugin serves as the execution engine for the [AI-Assisted Development Template](https://github.com/jhonatangs/ai-workflow-template), enabling zero-hallucination workflows and seamless cross-agent handoffs using the File System as an API.

## 🚀 Features

- **Strict Parameterization:** Requires explicit declaration of the harness and model to prevent accidental executions and token waste.
- **Universal Routing:** Abstracts the CLI syntax of multiple AI tools (Aider, OpenCode, Antigravity, OpenHands, etc.) into a unified set of commands.
- **Cross-Agent Handoff:** Easily pause an operation with a fast model (e.g., Gemini Flash) and resume it with a heavy-reasoning model (e.g., DeepSeek R1 or Claude 3.7 Sonnet) without losing context.
- **Prompt-Based Workflow:** Uses the `.ai/prompts/` files from the project to standardize start, fix, pause, resume, and ship operations.
- **Zsh Integration:** Provides short commands that can be sourced directly from `~/.zshrc`.

## 📦 Installation

### 1. Clone the repository

Clone this repository into a hidden directory in your home folder:

```bash
git clone https://github.com/jhonatangs/zsh-ai-workflow.git ~/.zsh-ai-workflow
```

### 2. Source the plugin

Add the following line to the end of your `~/.zshrc` file:

```bash
echo "source ~/.zsh-ai-workflow/ai-workflow.plugin.zsh" >> ~/.zshrc
```

### 3. Reload your terminal configuration

```bash
source ~/.zshrc
```

### 4. Verify the installation

Run one of the available commands with a supported harness and model:

```bash
ais <harness> <model>
```

For example:

```bash
ais antigravity gemini-3.8-flash
```

> The harness and model must be installed, configured, and available in your environment. Model identifiers vary by tool and provider.

## 🛠️ Usage

The syntax is intentionally strict.

Every command requires the harness and model:

```text
<command> <harness> <model>
```

For example:

```bash
ais antigravity gemini-3.8-flash
```

## Core Commands

### `ais` — Start

Triggers autonomous scaffolding based on the project's `.ai/todo.md` and `.ai/context.md`.

```bash
ais <harness> <model>
```

Example:

```bash
ais antigravity gemini-3.8-flash
```

### `aif` — Fix

Analyzes `TODO: AI` comments, recent errors, or project issues and asks the selected agent to fix them.

```bash
aif <harness> <model>
```

Example:

```bash
aif aider claude-3-7-sonnet
```

### `aipr` — Ship

Validates changes, prepares a Conventional Commit, and prepares a Pull Request when supported by the selected harness.

```bash
aipr <harness> <model>
```

Example:

```bash
aipr opencode deepseek-v4-pro
```

Always review generated changes, commits, and pull requests before pushing or merging them.

## 🔄 Cross-Agent Handoff Commands

### `aipause` — Check-out

Forces the current agent to stop execution and dump its current state, errors, decisions, and next steps into:

```text
.ai/handoff_state.md
```

Usage:

```bash
aipause <harness> <model>
```

Example:

```bash
aipause antigravity gemini-3.8-flash
```

### `airesume` — Check-in

Wakes up a new agent to read the `handoff_state.md` buffer and resume the task from the previous stopping point.

Usage:

```bash
airesume <harness> <model>
```

Example:

```bash
airesume opencode deepseek-v4-pro
```

## 💡 Complete Example

```bash
# 1. Start a data pipeline task using a fast model
ais antigravity gemini-3.8-flash

# 2. The task gets too complex; pause and save context
aipause antigravity gemini-3.8-flash

# 3. Resume the same task with a heavy-reasoning model
airesume opencode deepseek-v4-pro

# 4. Refactor a specific bug using Aider and Claude
aif aider claude-3-7-sonnet

# 5. Validate the changes and prepare the delivery
aipr opencode deepseek-v4-pro
```

> The model names in these examples are illustrative. Use model identifiers supported by the installed harness and provider.

## 🔌 Supported Harnesses

The router dynamically adapts to the CLI syntax of the following tools:
- `opencode`, `roo`, `roo-cline`, `cline`, `kilo-code`
- `aider`
- `openhands`, `swe-agent`, `agentless`, `autocoderover`
- `claude-code`, `goose`, `claw`, `manus`, `vellum`
- `cursor`, `windsurf`, `zed`
- `antigravity` (and any other tool that reads from `STDIN` via fallback)

Support may depend on the CLI being installed and available in the system `PATH`.

## 📁 Expected Project Structure

The plugin is designed to work with projects that contain the following files:

```text
project/
└── .ai/
    ├── todo.md
    ├── context.md
    ├── handoff_state.md
    ├── rules/
    └── prompts/
        ├── 1-start.txt
        ├── 2-fix.txt
        ├── 3-ship.txt
        ├── 4-pause.txt
        └── 5-resume.txt
```

The recommended project template is available here:

**[AI-Assisted Development Template](https://github.com/jhonatangs/ai-workflow-template)**

## ⚠️ Requirements and limitations

- Zsh must be installed and used as the active shell.
- Each selected AI harness must be installed separately.
- The selected model must be supported by the corresponding harness.
- Authentication and provider configuration are handled by each harness.
- The plugin routes commands and prompts; it does not install or configure the AI tools automatically.
- Generated code, commits, and pull requests must be reviewed by a human before production use.

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.
