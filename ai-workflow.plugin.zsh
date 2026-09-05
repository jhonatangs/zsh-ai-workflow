# ==========================================
# AI-Assisted Development Workflow (Strictly Parameterized)
# ==========================================

# 1. Template Initializer
ai-init() {
    if [ -d ".ai" ]; then
        echo "⚠️ The .ai directory already exists in this repository."
        return 1
    fi
    echo "🚀 Initializing AI Setup..."
    # Replace YOUR_USERNAME with your actual GitHub username
    git archive --remote=git@github.com:YOUR_USERNAME/ai-workflow-template.git main .ai | tar -x
    git archive --remote=git@github.com:YOUR_USERNAME/ai-workflow-template.git main .gitignore | tar -x
    echo "✅ AI Setup Template loaded successfully."
}

# 2. Parameterized Central Engine (Universal Router)
_ai_execute() {
    local prompt_file=$1
    local harness=$2
    local model=$3

    # Strict validation: Blocks execution if parameters are missing
    if [[ -z "$harness" || -z "$model" ]]; then
        echo "❌ Usage Error: You must explicitly declare the harness and the model."
        echo "💡 Example Start: ais antigravity gemini-3.8-flash"
        echo "💡 Example Resume: airesume opencode deepseek-v4-pro"
        return 1
    fi

    if [[ ! -f "$prompt_file" ]]; then
        echo "❌ Error: Prompt file '$prompt_file' not found. Are you in the project root?"
        return 1
    fi

    echo "⚡ Dispatching | Harness: [$harness] | Model: [$model]"

    # Syntactic adapters: Grouping harnesses by their CLI behavior
    # Add new cases here as you discover tools with different syntaxes
    case "$harness" in
        # CLIs that accept the file as a flag (e.g., OpenCode, Roo Code, Cline)
        opencode|roo|roo-cline|cline|kilo-code)
            "$harness" --model "$model" --prompt-file "$prompt_file"
            ;;
            
        # CLIs that natively manage Git diffs via a message flag
        aider)
            aider --model "$model" --message-file "$prompt_file"
            ;;
            
        # Heavy autonomous agents / Workspaces
        openhands|swe-agent|agentless|autocoderover)
            python -m "$harness".run --task-file "$prompt_file" --model "$model"
            ;;
            
        # Anthropic/OpenAI native tools or modern generic CLIs
        claude-code|goose|claw|manus|vellum)
            "$harness" --model "$model" -p "$(cat $prompt_file)"
            ;;
            
        # Direct integration with IDE CLIs
        cursor|windsurf|zed)
            "$harness" --prompt "$(cat $prompt_file)" --model "$model"
            ;;
            
        # Universal Fallback: Reads the file via STDIN and passes the model flag
        # (Standard for Antigravity, GitHub Copilot CLI, etc.)
        *)
            cat "$prompt_file" | "$harness" --model "$model"
            ;;
    esac
}

# 3. Strict Terminal Commands
# Mandatory syntax: <command> <harness> <model>
ais()      { _ai_execute ".ai/prompts/1-start.txt" "$1" "$2" }
aif()      { _ai_execute ".ai/prompts/2-fix.txt" "$1" "$2" }
aipr()     { _ai_execute ".ai/prompts/3-ship.txt" "$1" "$2" }
aipause()  { _ai_execute ".ai/prompts/4-pause.txt" "$1" "$2" }
airesume() { _ai_execute ".ai/prompts/5-resume.txt" "$1" "$2" }
