# ⚡ Zsh AI Workflow Plugin

A parameterized CLI router for Zsh designed to orchestrate autonomous AI agents directly from your terminal. This plugin serves as the execution engine for the [AI-Assisted Development Template](https://github.com/YOUR_USERNAME/ai-workflow-template), enabling zero-hallucination workflows and seamless cross-agent handoffs using the File System as an API.

## 🚀 Features

- **Strict Parameterization:** Requires explicit declaration of the harness and model to prevent accidental executions and token waste.
- **Universal Routing:** Abstracts the CLI syntax of multiple AI tools (Aider, OpenCode, Antigravity, OpenHands, etc.) into a unified set of commands.
- **Cross-Agent Handoff:** Easily pause an operation with a fast model (e.g., Gemini Flash) and resume it with a heavy-reasoning model (e.g., DeepSeek R1 or Claude 3.7 Sonnet) without losing context.

## 📦 Installation

1. Clone this repository into a hidden directory in your home folder:
   ```bash
   git clone [https://github.com/jhonatangs/zsh-ai-workflow.git](https://github.com/jhonatangs/zsh-ai-workflow.git) ~/.zsh-ai-workflow
   ```

2. Source the plugin at the end of your `~/.zshrc` file:
   ```bash
   echo "source ~/.zsh-ai-workflow/ai-workflow.plugin.zsh" >> ~/.zshrc
   ```

3. Reload your terminal configuration:
   ```bash
   source ~/.zshrc
   ```

## 🛠️ Usage

The syntax is strict. You **must** provide the harness and the model for every command: `<command> <harness> <model>`

### Core Commands

- **`ais <harness> <model>`** (Start): Triggers autonomous scaffolding based on your `.ai/todo.md` and `.ai/context.md`.
- **`aif <harness> <model>`** (Fix): Analyzes `TODO: AI` comments or recent linter errors to fix specific issues.
- **`aipr <harness> <model>`** (Ship): Validates changes, generates a Conventional Commit, and prepares a Pull Request.

### Cross-Agent Handoff Commands

- **`aipause <harness> <model>`** (Check-out): Forces the current agent to stop execution and dump its current state, errors, and next steps into `.ai/handoff_state.md`.
- **`airesume <harness> <model>`** (Check-in): Wakes up a new agent to read the `handoff_state.md` buffer and resume the task exactly where the previous agent left off.

### Examples

```bash
# 1. Start a data pipeline task using a fast model
ais antigravity gemini-3.8-flash

# 2. The task gets too complex, pause and save context
aipause antigravity gemini-3.8-flash

# 3. Resume the exact same task with a heavy-reasoning model
airesume opencode deepseek-v4-pro

# 4. Refactor a specific bug using Aider and Claude
aif aider claude-3-7-sonnet
```

## 🔌 Supported Harnesses

The router dynamically adapts to the CLI syntax of the following tools:
- `opencode`, `roo`, `roo-cline`, `cline`, `kilo-code`
- `aider`
- `openhands`, `swe-agent`, `agentless`, `autocoderover`
- `claude-code`, `goose`, `claw`, `manus`, `vellum`
- `cursor`, `windsurf`, `zed`
- `antigravity` (and any other tool that reads from `STDIN` via fallback)

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.
