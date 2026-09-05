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
    git archive --remote=git@github.com:YOUR_USERNAME/ai-workflow-template.git main .ai | tar -x
    git archive --remote=git@github.com:YOUR_USERNAME/ai-workflow-template.git main .gitignore | tar -x
    echo "✅ AI Setup Template loaded successfully."
}

# 2. Parameterized Central Engine (Universal Router)
_ai_execute() {
    local prompt_file="$1"
    local harness="$2"
    local model="$3"

    # Shift past prompt_file, harness, and model to capture any optional free-text prompt
    shift 3 2>/dev/null || shift $# 

    # Optional user prompt with todo.md autopilot fallback
    local USER_PROMPT="${1:-"Please read .ai/todo.md and strictly execute the next pending task. Autonomously update the checklist when finished."}"

    # Strict validation: Blocks execution if parameters are missing
    if [[ -z "$harness" || -z "$model" ]]; then
        echo "❌ Usage Error: You must explicitly declare the harness and the model."
        echo "💡 Example Start: ais antigravity gemini-3.8-flash \"Optional custom instruction\""
        echo "💡 Example Autopilot: ais antigravity gemini-3.8-flash"
        return 1
    fi

    if [[ ! -f "$prompt_file" ]]; then
        echo "❌ Error: Prompt file '$prompt_file' not found. Are you in the project root?"
        return 1
    fi

    echo "⚙️ Dispatching | Harness: [$harness] | Model: [$model]"

    # Read the prompt template and dynamically substitute the {{USER_PROMPT}} placeholder
    local prompt_content=$(< "$prompt_file")
    prompt_content="${prompt_content//\{\{USER_PROMPT\}\}/$USER_PROMPT}"

    # Syntactic adapters: Grouping harnesses by their CLI behavior
    case "$harness" in
        opencode|roo|roo-cline|cline|kilo-code)
            "$harness" --model "$model" --prompt "$prompt_content"
            ;;
        aider)
            aider --model "$model" --message "$prompt_content"
            ;;
        openhands|swe-agent|agentless|autocoderover)
            python -m "$harness".run --task "$prompt_content" --model "$model"
            ;;
        claude-code|goose|claw|manus|vellum)
            "$harness" --model "$model" -p "$prompt_content"
            ;;
        cursor|windsurf|zed)
            "$harness" --prompt "$prompt_content" --model "$model"
            ;;
        *)
            echo "$prompt_content" | "$harness" --model "$model"
            ;;
    esac
}

# 3. Strict Terminal Commands
# Mandatory syntax: <command> <harness> <model> [optional user prompt]
ais()      { _ai_execute ".ai/prompts/1-start.txt" "$@" }
aif()      { _ai_execute ".ai/prompts/2-fix.txt" "$@" }
aipr()     { _ai_execute ".ai/prompts/3-ship.txt" "$@" }
aipause()  { _ai_execute ".ai/prompts/4-pause.txt" "$@" }
airesume() { _ai_execute ".ai/prompts/5-resume.txt" "$@" }
