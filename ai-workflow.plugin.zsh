# ==========================================
# AI-Assisted Development Workflow (Strictly Parameterized)
# ==========================================

# 1. Template Initializer
ai-init() {
    if [[ -d ".ai" ]]; then
        echo "⚠️ The .ai directory already exists in this repository."
        return 1
    fi

    local repo="git@github.com:jhonatangs/ai-workflow-template.git"

    local files=(
        ".ai"
        ".gitignore"
    )

    local agents=()

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --agent)
                if [[ -z "$2" ]]; then
                    echo "❌ Missing value for --agent."
                    echo ""
                    echo "Usage:"
                    echo "  ai-init"
                    echo "  ai-init --agent cursor"
                    echo "  ai-init --agent cursor --agent copilot"
                    echo "  ai-init --all"
                    return 1
                fi

                agents+=("$2")
                shift 2
                ;;

            --all)
                agents=("cursor" "windsurf" "agents" "generic" "copilot")
                shift
                ;;

            --help|-h)
                echo "AI Workflow Initializer"
                echo ""
                echo "Usage:"
                echo "  ai-init"
                echo "  ai-init --agent cursor"
                echo "  ai-init --agent windsurf"
                echo "  ai-init --agent agents"
                echo "  ai-init --agent generic"
                echo "  ai-init --agent copilot"
                echo "  ai-init --agent cursor --agent copilot"
                echo "  ai-init --all"
                echo ""
                echo "Available agents:"
                echo "  cursor    -> .cursorrules"
                echo "  windsurf  -> .windsurfrules"
                echo "  agents    -> AGENTS.md"
                echo "  generic   -> AI_INSTRUCTIONS.md"
                echo "  copilot   -> .github/copilot-instructions.md"
                echo "  all       -> all supported instruction files"
                return 0
                ;;

            *)
                echo "❌ Unknown option: $1"
                echo "Use 'ai-init --help' for usage."
                return 1
                ;;
        esac
    done

    # Translate agent names into template files
    for agent in "${agents[@]}"; do
        case "$agent" in
            cursor)
                files+=(".cursorrules")
                ;;
            windsurf)
                files+=(".windsurfrules")
                ;;
            agents)
                files+=("AGENTS.md")
                ;;
            generic)
                files+=("AI_INSTRUCTIONS.md")
                ;;
            copilot)
                files+=(".github/copilot-instructions.md")
                ;;
            *)
                echo "❌ Unknown agent profile: $agent"
                echo ""
                echo "Supported agents:"
                echo "  cursor"
                echo "  windsurf"
                echo "  agents"
                echo "  generic"
                echo "  copilot"
                return 1
                ;;
        esac
    done

    echo "🚀 Initializing AI Workflow..."

    local temp_dir=$(mktemp -d)
    
    # Garantir limpeza do diretório temporário ao sair da função
    trap 'rm -rf "$temp_dir"' EXIT INT TERM

    # Shallow clone com sparse-checkout sem baixar o histórico completo
    if ! git clone --depth 1 --filter=blob:none --sparse "$repo" "$temp_dir" &>/dev/null; then
        echo "❌ Failed to connect to repository '$repo'."
        return 1
    fi

    # Definir os arquivos/diretórios que devem ser extraídos
    (
        cd "$temp_dir" || exit 1
        git sparse-checkout set "${files[@]}" &>/dev/null
    )

    # Copiar os arquivos solicitados para o diretório atual
    local item
    for item in "${files[@]}"; do
        if [[ -e "$temp_dir/$item" ]]; then
            if [[ -d "$temp_dir/$item" ]]; then
                cp -r "$temp_dir/$item" ./
            else
                mkdir -p "$(dirname "$item")"
                cp "$temp_dir/$item" "$item"
            fi
        fi
    done

    # Limpeza manual do diretório temporário
    rm -rf "$temp_dir"
    trap - EXIT INT TERM

    echo "✅ AI Workflow initialized successfully."

    if [[ ${#agents[@]} -gt 0 ]]; then
        echo "📦 Installed AI adapters:"
        printf '   - %s\n' "${agents[@]}"
    else
        echo "📦 Installed core workflow only."
    fi
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
