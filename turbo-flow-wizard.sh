#!/bin/bash

# Turbo Flow Wizard - Generate CLAUDE.pre for Claude Integration
# Ask questions → Generate CLAUDE.pre → Claude merges with root CLAUDE.md

set -euo pipefail

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly BOLD='\033[1m'
readonly NC='\033[0m'

# Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly WIKI_DIR="${SCRIPT_DIR}/claude-flow.wiki"
readonly CLAUDE_PRE_FILE="${SCRIPT_DIR}/CLAUDE.pre"
readonly SESSION_ID="setup_$(date +%s)"

# Logging
log() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
success() { echo -e "${GREEN}${BOLD}[SUCCESS]${NC} $1"; }

# Display banner
display_banner() {
    echo -e "${CYAN}${BOLD}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║     🚀 Claude Flow Setup Wizard v2.0.0 Alpha                ║
║     Generate CLAUDE.pre → Claude merges with CLAUDE.md       ║
║                                                              ║
║     📚 Powered by claude-flow.wiki directory                 ║
║     🎯 Interactive question system                          ║
║     📝 Optional context input                               ║
║     🔗 Seamless Claude integration                           ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Clone or update wiki directory
setup_wiki() {
    local wiki_repo="https://github.com/ruvnet/claude-flow.wiki.git"

    if [ ! -d "$WIKI_DIR" ]; then
        log "📥 Cloning claude-flow.wiki repository..."
        if command -v git >/dev/null 2>&1; then
            git clone "$wiki_repo" "$WIKI_DIR" || {
                error "❌ Failed to clone wiki repository"
                error "Please ensure git is installed and you have internet access"
                exit 1
            }
            success "✅ Wiki repository cloned successfully"
        else
            error "❌ Git not found. Please install git to clone the wiki repository"
            error "Or manually clone: git clone $wiki_repo $WIKI_DIR"
            exit 1
        fi
    else
        log "📚 Wiki directory already exists"
        # Optional: Update existing repo
        if [ -d "$WIKI_DIR/.git" ]; then
            log "🔄 Updating wiki repository..."
            cd "$WIKI_DIR" && git pull origin main >/dev/null 2>&1 && \
                success "✅ Wiki repository updated" || \
                warn "⚠️  Could not update wiki repository (using existing version)"
        fi
    fi
    success "✅ Wiki directory ready"
}

# Interactive questions
ask_questions() {
    echo -e "${PURPLE}${BOLD}🎯 Application Type Detection${NC}"
    echo

    # Primary category
    echo -e "${CYAN}📋 What type of application are you building?${NC}"
    echo "1) Web Application (Frontend + Backend)"
    echo "2) API / Microservice"
    echo "3) Mobile Application"
    echo "4) Desktop Application"
    echo "5) Data Science / Machine Learning"
    echo "6) Blockchain / Web3"
    echo "7) IoT / Embedded Systems"
    echo "8) Game Development"
    echo "9) DevOps / Infrastructure"
    echo "10) CLI Tool / Utility"
    echo "11) Documentation / Static Site"
    echo "12) Custom / Other"

    while true; do
        read -p "Enter choice (1-12): " app_choice
        case $app_choice in
            1) APP_CATEGORY="web"; APP_TYPE="fullstack"; break;;
            2) APP_CATEGORY="api"; APP_TYPE="microservice"; break;;
            3) APP_CATEGORY="mobile"; APP_TYPE="mobile"; break;;
            4) APP_CATEGORY="desktop"; APP_TYPE="desktop"; break;;
            5) APP_CATEGORY="data"; APP_TYPE="ml"; break;;
            6) APP_CATEGORY="blockchain"; APP_TYPE="web3"; break;;
            7) APP_CATEGORY="iot"; APP_TYPE="embedded"; break;;
            8) APP_CATEGORY="game"; APP_TYPE="game"; break;;
            9) APP_CATEGORY="devops"; APP_TYPE="infrastructure"; break;;
            10) APP_CATEGORY="cli"; APP_TYPE="utility"; break;;
            11) APP_CATEGORY="docs"; APP_TYPE="static"; break;;
            12) APP_CATEGORY="custom"; APP_TYPE="custom"; break;;
            *) echo -e "${RED}Invalid choice. Please enter 1-12.${NC}";;
        esac
    done

    # Technology stack
    echo
    echo -e "${CYAN}🛠️  Technology Stack${NC}"

    # Frontend
    if [[ "$APP_CATEGORY" == "web" || "$APP_CATEGORY" == "mobile" ]]; then
        echo "Frontend framework:"
        echo "1) React  2) Vue.js  3) Angular  4) Svelte  5) Next.js  6) Nuxt.js  7) React Native  8) Flutter  9) None"
        read -p "Frontend choice (1-9): " frontend_choice
        case $frontend_choice in
            1) FRONTEND="React";;
            2) FRONTEND="Vue.js";;
            3) FRONTEND="Angular";;
            4) FRONTEND="Svelte";;
            5) FRONTEND="Next.js";;
            6) FRONTEND="Nuxt.js";;
            7) FRONTEND="React Native";;
            8) FRONTEND="Flutter";;
            9) FRONTEND="None";;
            *) FRONTEND="React";;
        esac
    fi

    # Backend
    if [[ "$APP_CATEGORY" == "web" || "$APP_CATEGORY" == "api" ]]; then
        echo "Backend framework:"
        echo "1) Node.js/Express  2) Node.js/Fastify  3) Node.js/NestJS  4) Python/Django  5) Python/FastAPI  6) Python/Flask  7) Go  8) Rust  9) Java/Spring  10) .NET Core  11) Serverless"
        read -p "Backend choice (1-11): " backend_choice
        case $backend_choice in
            1) BACKEND="Node.js/Express";;
            2) BACKEND="Node.js/Fastify";;
            3) BACKEND="Node.js/NestJS";;
            4) BACKEND="Python/Django";;
            5) BACKEND="Python/FastAPI";;
            6) BACKEND="Python/Flask";;
            7) BACKEND="Go";;
            8) BACKEND="Rust";;
            9) BACKEND="Java/Spring";;
            10) BACKEND=".NET Core";;
            11) BACKEND="Serverless";;
            *) BACKEND="Node.js/Express";;
        esac
    fi

    # Database
    if [[ "$APP_CATEGORY" == "web" || "$APP_CATEGORY" == "api" || "$APP_CATEGORY" == "data" ]]; then
        echo "Database:"
        echo "1) PostgreSQL  2) MySQL  3) MongoDB  4) Redis  5) SQLite  6) Elasticsearch  7) DynamoDB  8) Firebase  9) No database"
        read -p "Database choice (1-9): " db_choice
        case $db_choice in
            1) DATABASE="PostgreSQL";;
            2) DATABASE="MySQL";;
            3) DATABASE="MongoDB";;
            4) DATABASE="Redis";;
            5) DATABASE="SQLite";;
            6) DATABASE="Elasticsearch";;
            7) DATABASE="DynamoDB";;
            8) DATABASE="Firebase";;
            9) DATABASE="None";;
            *) DATABASE="PostgreSQL";;
        esac
    fi

    # Methodology
    echo
    echo -e "${CYAN}🔄 Development Methodology${NC}"
    echo "1) SPARC (Specification, Pseudocode, Architecture, Refinement, Completion)"
    echo "2) Test-Driven Development (TDD)"
    echo "3) Behavior-Driven Development (BDD)"
    echo "4) Agile/Scrum"
    echo "5) Feature-Driven Development"
    echo "6) Domain-Driven Design (DDD)"
    echo "7) Lean Development"

    read -p "Methodology choice (1-7): " method_choice
    case $method_choice in
        1) METHODOLOGY="SPARC";;
        2) METHODOLOGY="TDD";;
        3) METHODOLOGY="BDD";;
        4) METHODOLOGY="Agile/Scrum";;
        5) METHODOLOGY="Feature-Driven";;
        6) METHODOLOGY="DDD";;
        7) METHODOLOGY="Lean";;
        *) METHODOLOGY="SPARC";;
    esac

    # Features
    echo
    echo -e "${CYAN}✨ Features (space-separated numbers)${NC}"
    echo "1) Authentication  2) Real-time (WebSockets)  3) File uploads  4) Payments  5) Email"
    echo "6) Search  7) Caching  8) Rate limiting  9) Monitoring  10) CI/CD"
    echo "11) Docker  12) Testing  13) Documentation  14) Performance  15) Security"
    echo "16) GitHub integration  17) Pair programming  18) Swarm orchestration  19) All features"

    read -p "Feature numbers: " feature_input

    # Parse features
    FEATURES=()
    for feature_num in $feature_input; do
        case $feature_num in
            1) FEATURES+=("Authentication");;
            2) FEATURES+=("Real-time WebSockets");;
            3) FEATURES+=("File uploads/storage");;
            4) FEATURES+=("Payment processing");;
            5) FEATURES+=("Email services");;
            6) FEATURES+=("Search functionality");;
            7) FEATURES+=("Caching layer");;
            8) FEATURES+=("API rate limiting");;
            9) FEATURES+=("Monitoring & logging");;
            10) FEATURES+=("CI/CD pipeline");;
            11) FEATURES+=("Docker containerization");;
            12) FEATURES+=("Testing framework");;
            13) FEATURES+=("Documentation generation");;
            14) FEATURES+=("Performance optimization");;
            15) FEATURES+=("Security scanning");;
            16) FEATURES+=("GitHub integration");;
            17) FEATURES+=("Pair programming");;
            18) FEATURES+=("Swarm orchestration");;
            19) FEATURES+=("All features");;
        esac
    done
}

# Optional context input
get_optional_context() {
    echo
    echo -e "${PURPLE}${BOLD}📝 Optional Project Context${NC}"
    echo -e "${YELLOW}Provide additional details about your project (press Enter when done):${NC}"
    echo "Examples: What problem does it solve? Who are the users? Any specific requirements?"
    echo "--------------------------------------------------------------------------------"

    # Use temporary file for multi-line input
    local temp_context=$(mktemp)

    # Read multi-line input
    while IFS= read -r line; do
        [ "$line" = "###END###" ] && break
        echo "$line" >> "$temp_context"
    done

    PROJECT_CONTEXT=$(cat "$temp_context" 2>/dev/null || echo "")
    rm -f "$temp_context"

    if [ -n "$PROJECT_CONTEXT" ]; then
        success "✅ Project context captured"
    else
        warn "⚠️  No additional context provided"
    fi
}

# Generate CLAUDE.pre file
generate_claude_pre() {
    log "📄 Generating CLAUDE.pre file..."

    cat > "$CLAUDE_PRE_FILE" << EOF
# Claude Configuration Pre-merge - Generated by Claude Flow Setup Wizard
# Session: $SESSION_ID
# Generated: $(date)

# ==========================================
# PROJECT DETECTED CONFIGURATION
# ==========================================

## Application Type
- **Category**: $APP_CATEGORY
- **Type**: $APP_TYPE
- **Frontend**: ${FRONTEND:-"Not applicable"}
- **Backend**: ${BACKEND:-"Not applicable"}
- **Database**: ${DATABASE:-"Not applicable"}
- **Methodology**: $METHODOLOGY
- **Features**: ${FEATURES[*]}

## Optional Project Context
$PROJECT_CONTEXT

# ==========================================
# CLAUDE INTEGRATION INSTRUCTIONS
# ==========================================

## Dear Claude,

Please merge the configuration above with the existing CLAUDE.md in the root directory, keeping all relevant context from the original file while integrating the new project-specific configuration.

### Integration Guidelines:
1. **Preserve** all existing critical configurations from root CLAUDE.md
2. **Add** the detected project configuration in an appropriate section
3. **Integrate** features that match the project needs
4. **Maintain** all existing execution rules and best practices
5. **Adapt** verification system settings based on project type
6. **Include** relevant MCP tools and agent patterns for this stack

### Focus Areas for Integration:
- Technology stack specific configurations
- Development methodology implementation ($METHODOLOGY)
- Feature integration for: ${FEATURES[*]}
- Verification and testing setup
- File organization patterns
- Agent coordination protocols
- Swarm orchestration if applicable

### Special Considerations:
- This is a $APP_TYPE project with $FRONTEND frontend and $BACKEND backend
- Database: $DATABASE
- Development approach: $METHODOLOGY methodology
- Key features to implement: ${FEATURES[*]}

Please create a cohesive, optimized CLAUDE.md that combines the best of both configurations.

---
*Generated by Claude Flow Setup Wizard v2.0.0*
EOF

    success "✅ CLAUDE.pre file generated: $CLAUDE_PRE_FILE"
}

# Run Claude merge command
run_claude_merge() {
    log "🤖 Running Claude merge command..."
    echo
    echo -e "${CYAN}${BOLD}🧠 Claude Integration in Progress...${NC}"
    echo -e "${YELLOW}Command: claude \"take the CLAUDE.pre file and merge with CLAUDE.md and optimize for the build context contained in the claude.pre\"${NC}"
    echo

    # Check if claude command is available
    if command -v claude >/dev/null 2>&1; then
        log "🚀 Executing Claude merge command..."

        # Run the claude command
        claude "take the CLAUDE.pre file and merge with CLAUDE.md and optimize for the build context contained in the claude.pre" &

        local claude_pid=$!
        echo "🤖 Claude merge started (PID: $claude_pid)"
        log "Claude merge process launched with PID: $claude_pid"

        # Give Claude time to process
        sleep 2

        # Check if Claude is still running
        if kill -0 "$claude_pid" 2>/dev/null; then
            success "✅ Claude merge is running in background"
            echo -e "${GREEN}📊 Claude is now merging CLAUDE.pre with CLAUDE.md...${NC}"
        else
            success "✅ Claude merge completed quickly"
        fi

    else
        warn "⚠️  Claude CLI not found in PATH"
        echo
        echo -e "${YELLOW}📝 Manual Claude Command Required:${NC}"
        echo "   Please run this command manually:"
        echo -e "${CYAN}   claude \"take the CLAUDE.pre file and merge with CLAUDE.md and optimize for the build context contained in the claude.pre\"${NC}"
        echo
        echo -e "${YELLOW}💡 To install Claude CLI:${NC}"
        echo "   npm install -g @anthropic-ai/claude-code"
        echo "   claude --dangerously-skip-permissions"
    fi
}

# Display completion status
show_completion_status() {
    echo
    echo -e "${GREEN}${BOLD}🎉 Setup Complete!${NC}"
    echo
    echo -e "${CYAN}📋 Generated Files:${NC}"
    echo "   📄 CLAUDE.pre - Project configuration for Claude integration"
    echo "   🤖 Claude merge initiated - optimizing CLAUDE.md"
    echo
    echo -e "${CYAN}🚀 What Happened:${NC}"
    echo "   1. ✅ Project configuration detected via questions"
    echo "   2. ✅ Optional context captured"
    echo "   3. ✅ CLAUDE.pre file generated with integration instructions"
    echo "   4. 🤖 Claude merge command executed"
    echo "   5. ⏳ Claude is now optimizing CLAUDE.md for your project"
    echo
    echo -e "${YELLOW}📊 Configuration Summary:${NC}"
    echo "   📁 App Type: $APP_TYPE ($APP_CATEGORY)"
    echo "   🛠️  Stack: $FRONTEND + $BACKEND + $DATABASE"
    echo "   🔄 Methodology: $METHODOLOGY"
    echo "   ✨ Features: ${FEATURES[*]}"
    echo "   📄 Generated: CLAUDE.pre"
    echo "   🤖 Status: Claude merge in progress"
    echo
    echo -e "${GREEN}${BOLD}✨ Your project configuration is being optimized by Claude!${NC}"
}

# Main execution
main() {
    display_banner
    setup_wiki
    ask_questions
    get_optional_context
    generate_claude_pre
    run_claude_merge
    show_completion_status
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
