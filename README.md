# Turbo Flow Wizard 
## Overview

The `turbo-flow-wizard.sh` script is an interactive setup wizard that generates project-specific configuration files for Claude integration. It guides users through a series of questions about their project and automatically generates a `CLAUDE.pre` file that can be merged with existing `CLAUDE.md` configuration.

IMPORTANT: Execute this from your claude working directory so the API credentials are passed along.

## Purpose

The wizard is designed to:
- Detect project requirements through interactive questions
- Generate tailored Claude configuration based on user responses
- Automate the setup of Claude Code with project-specific settings
- Integrate with the claude-flow.wiki repository for comprehensive documentation

## Prerequisites

### Required
- **Git** - Required for cloning the claude-flow.wiki repository
- **Bash** - Compatible shell environment
- **Internet Connection** - Required for initial wiki repository clone

### Optional (for full functionality)
- **Claude CLI** - Required for automatic merge functionality
  - Install via: `npm install -g @anthropic-ai/claude-code`

## Usage

### Basic Execution

```bash
# Run the wizard
./turbo-flow-wizard.sh
```

### Permissions

Make sure the script is executable:
```bash
chmod +x turbo-flow-wizard.sh
```

## Workflow

The wizard follows a 5-step process:

1. **Setup Wiki Repository** - Clones or updates the claude-flow.wiki repository
2. **Interactive Questions** - Collects project information
3. **Generate CLAUDE.pre** - Creates project-specific configuration
4. **Claude Merge** - Automatically merges configurations (if Claude CLI is available)
5. **Completion** - Displays results and cleanup

## Interactive Questions

### Application Type Selection

The wizard offers 12 application categories:

1. **Web Application** - Full-stack frontend + backend
2. **API / Microservice** - Backend-only services
3. **Mobile Application** - iOS/Android development
4. **Desktop Application** - Native desktop apps
5. **Data Science / Machine Learning** - ML/DS projects
6. **Blockchain / Web3** - Blockchain and cryptocurrency projects
7. **IoT / Embedded Systems** - Internet of Things projects
8. **Game Development** - Gaming applications
9. **DevOps / Infrastructure** - Infrastructure as code
10. **CLI Tool / Utility** - Command-line tools
11. **Documentation / Static Site** - Documentation sites
12. **Custom / Other** - Custom project types

### Technology Stack Configuration

Based on the application type, the wizard configures:

#### Frontend Options (for Web/Mobile)
- React, Vue.js, Angular, Svelte
- Next.js, Nuxt.js
- React Native, Flutter

#### Backend Options (for Web/API)
- Node.js variants: Express, Fastify, NestJS
- Python variants: Django, FastAPI, Flask
- Go, Rust, Java/Spring, .NET Core
- Serverless architectures

#### Database Options (for Web/API/Data)
- SQL: PostgreSQL, MySQL, SQLite
- NoSQL: MongoDB, Redis, Elasticsearch
- Cloud: DynamoDB, Firebase, Supabase

### Development Methodology

Choose from 7 development approaches:

1. **SPARC** - Specification, Pseudocode, Architecture, Refinement, Completion
2. **TDD** - Test-Driven Development
3. **BDD** - Behavior-Driven Development
4. **Agile/Scrum** - Agile methodology
5. **Feature-Driven Development** - Feature-centric approach
6. **Domain-Driven Design (DDD)** - Domain modeling approach
7. **Lean Development** - Lean methodology

### Features Selection

Select any combination of 19 available features:

- **Core Features**: Authentication, Real-time (WebSockets), File uploads, Payments, Email
- **Infrastructure**: Search, Caching, Rate limiting, Monitoring, CI/CD
- **Development**: Docker, Testing, Documentation, Performance, Security
- **Collaboration**: GitHub integration, Pair programming, Swarm orchestration
- **Complete**: All features (option 19)

## Generated Files

### CLAUDE.pre

The wizard generates a `CLAUDE.pre` file containing:

```yaml
# Project Configuration
- Application Type: [category/type]
- Technology Stack: [frontend + backend + database]
- Development Methodology: [chosen methodology]
- Features: [selected features]
- Integration instructions for Claude
```

### File Structure

```
project/
├── turbo-flow-wizard.sh      # The wizard script
├── CLAUDE.md                 # Existing Claude configuration
├── CLAUDE.md.OLD            # Backup of original configuration
├── CLAUDE.pre               # Generated configuration (temporary)
└── claude-flow.wiki/        # Wiki repository (auto-cloned)
    ├── _Sidebar.md
    ├── Configuration
    ├── Guides
    └── ...
```

## Integration Process

### Automatic Merge (Recommended)

If the Claude CLI is installed, the wizard automatically executes:

```bash
claude --dangerously-skip-permissions "Please merge CLAUDE.pre, CLAUDE.md, and CLAUDE.md.OLD into an optimized CLAUDE.md"
```

The merge process:
1. **Preserves** critical configurations from all three files
2. **Integrates** new project-specific settings
3. **Optimizes** for the detected project type
4. **Cleans up** temporary files

### Manual Merge (Fallback)

If Claude CLI is not available, the wizard provides a manual command:

```bash
claude "Please merge CLAUDE.pre, CLAUDE.md, and CLAUDE.md.OLD into an optimized CLAUDE.md"
```

## Configuration Variables

The wizard sets these internal variables based on user responses:

- `APP_CATEGORY` - High-level category (web, api, mobile, etc.)
- `APP_TYPE` - Specific type (fullstack, microservice, etc.)
- `FRONTEND` - Frontend framework
- `BACKEND` - Backend framework
- `DATABASE` - Database choice
- `METHODOLOGY` - Development approach
- `FEATURES` - Array of selected features
- `SESSION_ID` - Unique session identifier

## Error Handling

The wizard includes comprehensive error handling:

- **Git not found** - Provides manual clone instructions
- **Network issues** - Continues with existing wiki if available
- **Invalid input** - Re-prompts for valid choices
- **Permission issues** - Clear error messages and resolution steps

## Logging and Output

The wizard uses color-coded logging:

- 🔵 **INFO** (`[INFO]`) - General information messages
- 🟡 **WARN** (`[WARN]`) - Warning messages
- 🔴 **ERROR** (`[ERROR]`) - Error messages
- 🟢 **SUCCESS** (`[SUCCESS]`) - Success messages

## Troubleshooting

### Common Issues

1. **Git not installed**
   ```bash
   # Install git (Ubuntu/Debian)
   sudo apt-get install git

   # Install git (macOS)
   brew install git
   ```

2. **Claude CLI not found**
   ```bash
   # Install Claude CLI
   npm install -g @anthropic-ai/claude-code
   ```

3. **Permission denied**
   ```bash
   # Make script executable
   chmod +x turbo-flow-wizard.sh
   ```

4. **Wiki repository issues**
   - The wizard automatically handles missing wiki repositories
   - Existing wiki repositories are updated if possible
   - Script continues with existing version if update fails

### Manual Recovery

If the wizard fails, you can:
1. Manually clone the wiki repository
2. Run the wizard again
3. Manually merge generated files

```bash
# Manual wiki setup
git clone https://github.com/ruvnet/claude-flow.wiki.git claude-flow.wiki

# Restart wizard
./turbo-flow-wizard.sh
```

## Best Practices

1. **Run from project root** - Execute the wizard from your project's root directory
2. **Backup existing configuration** - The wizard automatically creates `CLAUDE.md.OLD`
3. **Review generated configuration** - Check `CLAUDE.pre` before automatic merge
4. **Commit changes** - After merge, commit the updated `CLAUDE.md` to version control

## Version Information

- **Current Version**: v2.0.0 Alpha
- **Compatibility**: Claude Code with claude-flow integration
- **Wiki Repository**: https://github.com/ruvnet/claude-flow.wiki.git

## Support

For issues or questions:
1. Check the claude-flow.wiki repository for documentation
2. Review the generated `CLAUDE.pre` file for configuration details
3. Verify Claude CLI installation for automatic merge functionality

---

*This manual documents the turbo-flow-wizard.sh script v2.0.0 Alpha for Claude Flow Setup Wizard.*
