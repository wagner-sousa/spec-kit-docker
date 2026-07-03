# Spec Kit Docker

A Docker template for [GitHub Spec Kit](https://github.com/github/spec-kit) - Spec-Driven Development toolkit.

### Prerequisites

- Docker and Docker Compose installed
- Git

### Quick Start

1. Build the image:

```bash
docker compose -f docker.compose.specify.yml build
```

2. Run specify commands:

```bash
./specify init . --integration copilot
./specify check
./specify --help
```

### Available Commands

After initialization, use these slash commands in your AI coding agent:

| Command | Description |
|---------|-------------|
| `/speckit.constitution` | Create project principles and guidelines |
| `/speckit.specify` | Define what you want to build |
| `/speckit.plan` | Create technical implementation plan |
| `/speckit.tasks` | Generate task breakdown |
| `/speckit.implement` | Execute implementation |

### Workflow

1. `/speckit.constitution` - Establish project principles
2. `/speckit.specify` - Define requirements (focus on what/why, not tech stack)
3. `/speckit.plan` - Create technical plan with your tech stack
4. `/speckit.tasks` - Break down into actionable tasks
5. `/speckit.implement` - Execute the implementation

### Docker Compose Configuration

- **File**: `docker.compose.specify.yml`
- **Container**: `specify`
- **Working directory**: `/workspace`
- **Volume mount**: Current directory mapped to `/workspace`
- **Port**: 8080 (for documentation site)

### Stopping the Container

```bash
docker compose -f docker.compose.specify.yml down
```
