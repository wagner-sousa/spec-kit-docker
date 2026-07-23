# Spec Kit Docker Template

[![Spec Kit](https://img.shields.io/badge/Spec%20Kit-0.12.5-blue)](https://github.com/github/spec-kit)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)
[![OpenCode](https://img.shields.io/badge/OpenCode-Integration-purple)](https://github.com/opencode-ai/opencode)

Template Docker para [GitHub Spec Kit](https://github.com/github/spec-kit) - Ferramenta de desenvolvimento orientado por especificações (Spec-Driven Development).

## Visão Geral

Este repositório é um template completo para projetos que utilizam Spec Kit com Docker. Inclui todas as extensões configuradas e prontas para uso, servindo como base para futuros projetos.

### Pré-requisitos

- Docker e Docker Compose instalados
- Git
- AI Coding Agent (opencode, copilot, etc.)

## Início Rápido

### 1. Build da Imagem

```bash
docker compose -f docker-compose.specify.yml build
```

### 2. Inicializar Projeto

```bash
./specify init . --integration opencode
```

### 3. Iniciar Fluxo SDD

```bash
./specify constitution
./specify specify "Descrição da feature"
```

## Fluxo de Trabalho Spec Kit

### Ciclo Principal SDD

```mermaid
graph TD
    A[speckit.constitution] -->|Define princípios| B[speckit.specify]
    B -->|Define requisitos| C[speckit.plan]
    C -->|Plano técnico| D[speckit.tasks]
    D -->|Gera tarefas| E[speckit.implement]
    E -->|Implementa| F{Review & Verify}
    F -->|Aprovado| G[PR/Deploy]
    F -->|Reprovado| E

    style A fill:#e1f5fe
    style B fill:#e1f5fe
    style C fill:#e1f5fe
    style D fill:#e1f5fe
    style E fill:#c8e6c9
    style F fill:#fff3e0
    style G fill:#c8e6c9
```

### Fluxo com Hooks

```mermaid
graph LR
    subgraph "Before Hooks"
        A1[before_constitution] --> A2[before_specify]
        A2 --> A3[before_plan]
        A3 --> A4[before_tasks]
        A4 --> A5[before_implement]
    end

    subgraph "Comandos Principais"
        B1[constitution] --> B2[specify]
        B2 --> B3[plan]
        B3 --> B4[tasks]
        B4 --> B5[implement]
    end

    subgraph "After Hooks"
        C1[after_constitution] --> C2[after_specify]
        C2 --> C3[after_plan]
        C3 --> C4[after_tasks]
        C4 --> C5[after_implement]
    end

    A1 -.-> B1
    A2 -.-> B2
    A3 -.-> B3
    A4 -.-> B4
    A5 -.-> B5
    B1 -.-> C1
    B2 -.-> C2
    B3 -.-> C3
    B4 -.-> C4
    B5 -.-> C5
```

## Extensões Instaladas

### Visão Geral das Extensões

```mermaid
graph TB
    subgraph "Core"
        A[Agent-Context]
        B[Git]
    end

    subgraph "Quality"
        C[Review]
        D[Verify]
        E[Verify-Tasks]
    end

    subgraph "Workflow"
        F[Sync]
        G[Bugfix]
        H[Refine]
    end

    subgraph "Diagnostics"
        I[Doctor]
    end

    A -->|Atualiza contexto| J[Coding Agent]
    B -->|Gerencia branches| K[Git Repository]
    C -->|Review código| L[Code Quality]
    D -->|Valida implementação| M[Spec Alignment]
    E -->|Detecta phantom| N[Task Completion]
    F -->|Detecta drift| O[Spec Drift]
    G -->|Bug workflow| P[Bugfix]
    H -->|Refina specs| Q[Specification]
    I -->|Diagnóstico| R[Project Health]
```

### Fluxo da Extensão Git

```mermaid
graph TD
    subgraph "Branch Management"
        A[before_constitution] -->|Initialize| B[git initialize]
        C[before_specify] -->|Create branch| D[git feature]
    end

    subgraph "Auto-Commit"
        E[before_clarify] -->|Commit| F[git commit]
        G[before_plan] -->|Commit| F
        H[before_tasks] -->|Commit| F
        I[before_implement] -->|Commit| F
        J[after_constitution] -->|Commit| F
        K[after_specify] -->|Commit| F
        L[after_plan] -->|Commit| F
        M[after_tasks] -->|Commit| F
        N[after_implement] -->|Commit| F
    end
```

### Fluxo da Extensão Review

```mermaid
graph TD
    A[after_implement] --> B{speckit.review.run}

    B --> C[Code Reviewer]
    B --> D[Comment Analyzer]
    B --> E[Test Analyzer]
    B --> F[Error Handler]
    B --> G[Type Design]
    B --> H[Simplify]

    C --> I[Relatório Consolidado]
    D --> I
    E --> I
    F --> I
    G --> I
    H --> I

    I --> J{Aprovado?}
    J -->|Sim| K[Prosseguir]
    J -->|Não| L[Corrigir Issues]
    L --> B
```

### Fluxo da Extensão Verify

```mermaid
graph TD
    A[after_implement] --> B[speckit.verify.run]
    B --> C[Valida vs spec.md]
    B --> D[Valida vs plan.md]
    B --> E[Valida vs tasks.md]

    C --> F{Alignment OK?}
    D --> F
    E --> F

    F -->|Sim| G[Implementação Válida]
    F -->|Não| H[Relatório de Desvios]
    H --> I[Corrigir Implementação]
    I --> B
```

### Fluxo da Extensão Sync

```mermaid
graph TD
    A[after_implement] --> B[speckit.sync.analyze]
    B --> C{Drift Detectado?}

    C -->|Não| D[Sem Desvios]
    C -->|Sim| E[speckit.sync.propose]
    E --> F[Propostas de Resolução]
    F --> G{Aprovar?}
    G -->|Sim| H[speckit.sync.apply]
    G -->|Não| I[Revisar Manualmente]
    H --> J[Specs Atualizados]
```

### Fluxo da Extensão Bugfix

```mermaid
graph TD
    A[Identificar Bug] --> B[speckit.bugfix.report]
    B --> C[Trace to Spec Artifacts]
    C --> D[speckit.bugfix.patch]
    D --> E[Atualiza Spec/Plan/Tasks]
    E --> F[after_implement]
    F --> G[speckit.bugfix.verify]
    G --> H{Consistente?}
    H -->|Sim| I[Bugfix Completo]
    H -->|Não| J[Corrigir Artefatos]
    J --> D
```

### Fluxo da Extensão Refine

```mermaid
graph TD
    A[Nova Requisição] --> B[speckit.refine.update]
    B --> C[Atualiza spec.md]
    C --> D[speckit.refine.propagate]
    D --> E[Atualiza plan.md]
    D --> F[Atualiza tasks.md]

    G[after_specify] --> H[speckit.refine.status]
    H --> I{Status Sync}
    I -->|OK| J[Artefatos Sincronizados]
    I -->|Stale| K[speckit.refine.diff]
    K --> L[Mostra Mudanças]
```

### Fluxo Completo com Todas as Extensões

```mermaid
graph TB
    subgraph "Fase 1: Setup"
        A1[before_constitution] --> A2[git initialize]
        A2 --> A3[speckit.constitution]
        A3 --> A4[after_constitution]
        A4 --> A5[git commit]
        A4 --> A6[agent-context update]
    end

    subgraph "Fase 2: Especificação"
        B1[before_specify] --> B2[git feature]
        B2 --> B3[speckit.specify]
        B3 --> B4[after_specify]
        B4 --> B5[git commit]
        B4 --> B6[agent-context update]
        B4 --> B7[refine status]
    end

    subgraph "Fase 3: Planejamento"
        C1[before_plan] --> C2[git commit]
        C2 --> C3[speckit.plan]
        C3 --> C4[after_plan]
        C4 --> C5[git commit]
        C4 --> C6[agent-context update]
        C4 --> C7[refine status]
    end

    subgraph "Fase 4: Tarefas"
        D1[before_tasks] --> D2[git commit]
        D2 --> D3[speckit.tasks]
        D3 --> D4[after_tasks]
        D4 --> D5[git commit]
    end

    subgraph "Fase 5: Implementação"
        E1[before_implement] --> E2[git commit]
        E2 --> E3[speckit.implement]
        E3 --> E4[after_implement]
        E4 --> E5[git commit]
        E4 --> E6[review.run]
        E4 --> E7[verify.run]
        E4 --> E8[verify-tasks.run]
        E4 --> E9[sync.analyze]
        E4 --> E10[bugfix.verify]
    end

    A6 -.-> B1
    B7 -.-> C1
    C7 -.-> D1
    D5 -.-> E1
```

## Comandos Disponíveis

### Comandos Principais Spec Kit

| Comando | Descrição | Extensão |
|---------|-----------|----------|
| `/speckit.constitution` | Cria princípios do projeto | Core |
| `/speckit.specify` | Define o que construir | Core |
| `/speckit.plan` | Cria plano técnico | Core |
| `/speckit.tasks` | Gera breakdown de tarefas | Core |
| `/speckit.implement` | Executa implementação | Core |
| `/speckit.clarify` | Esclarece requisitos | Core |
| `/speckit.analyze` | Analisa projeto | Core |
| `/speckit.checklist` | Gera checklist | Core |
| `/speckit.converge` | Converge artefatos | Core |
| `/speckit.taskstoissues` | Converte tasks para issues | Core |

### Comandos das Extensões

| Extensão | Comando | Descrição |
|----------|---------|-----------|
| **Git** | `speckit.git.feature` | Cria branch feature |
| | `speckit.git.validate` | Valida branch |
| | `speckit.git.remote` | Detecta remote |
| | `speckit.git.initialize` | Inicializa repo |
| | `speckit.git.commit` | Auto-commit |
| **Agent-Context** | `speckit.agent-context.update` | Atualiza contexto |
| **Review** | `speckit.review.run` | Review completo |
| | `speckit.review.code` | Code quality |
| | `speckit.review.comments` | Análise comentários |
| | `speckit.review.tests` | Cobertura testes |
| | `speckit.review.errors` | Error handling |
| | `speckit.review.types` | Type design |
| | `speckit.review.simplify` | Simplificação |
| **Verify** | `speckit.verify.run` | Valida implementação |
| **Verify-Tasks** | `speckit.verify-tasks.run` | Detecta phantom |
| **Sync** | `speckit.sync.analyze` | Analisa drift |
| | `speckit.sync.propose` | Propõe resoluções |
| | `speckit.sync.apply` | Aplica resoluções |
| | `speckit.sync.conflicts` | Detecta conflitos |
| | `speckit.sync.backfill` | Gera spec de código |
| **Bugfix** | `speckit.bugfix.report` | Reporta bug |
| | `speckit.bugfix.patch` | Aplica patch |
| | `speckit.bugfix.verify` | Verifica patch |
| **Refine** | `speckit.refine.update` | Atualiza spec |
| | `speckit.refine.propagate` | Propaga mudanças |
| | `speckit.refine.diff` | Mostra diferenças |
| | `speckit.refine.status` | Status sync |
| **Doctor** | `speckit.doctor.check` | Diagnóstico |

## Estrutura do Projeto

```
spec-kit-docker/
├── .specify/                    # Configuração Spec Kit
│   ├── extensions/              # Extensões instaladas
│   │   ├── agent-context/       # Gerenciamento contexto
│   │   ├── bugfix/              # Workflow bugfix
│   │   ├── doctor/              # Diagnóstico
│   │   ├── git/                 # Git workflow
│   │   ├── refine/              # Refinamento specs
│   │   ├── review/              # Code review
│   │   ├── sync/                # Sync specs/código
│   │   ├── verify/              # Validação implementação
│   │   └── verify-tasks/        # Detecção phantom
│   ├── integrations/            # Integrações (opencode, etc.)
│   ├── memory/                  # Constituição
│   ├── scripts/                 # Scripts auxiliares
│   ├── templates/               # Templates de artefatos
│   ├── workflows/               # Workflows SDD
│   ├── extensions.yml           # Config extensões
│   ├── integration.json         # Config integração
│   └── init-options.json        # Opções inicialização
├── .opencode/                   # Configuração OpenCode
│   └── commands/                # 41 comandos speckit.*
├── docker-compose.specify.yml   # Docker Compose
├── Dockerfile                   # Imagem Docker
├── post-create.sh               # Script setup
├── specify                      # Script wrapper
└── README.md                    # Este arquivo
```

## Configuração

### Auto-Commit (Git Extension)

Edite `.specify/extensions/git/git-config.yml`:

```yaml
auto_commit:
  default: true  # Habilita para todos os comandos
  before_implement:
    enabled: true
    message: "[Spec Kit] Save progress before implementation"
  after_implement:
    enabled: true
    message: "[Spec Kit] Implementation progress"
```

### Agentes de Review

Edite `.specify/extensions/review/review-config.yml`:

```yaml
agents:
  code: true
  comments: true
  tests: true
  errors: true
  types: true
  simplify: true
```

### Drift Detection (Sync Extension)

Edite `.specify/extensions/sync/sync-config.yml`:

```yaml
analysis:
  include_design_docs: true
  ignore_patterns:
    - "**/node_modules/**"
proposals:
  default_strategy: ask
  min_confidence: 0.7
```

## Como Usar como Template

1. **Clone este repositório**
   ```bash
   git clone https://github.com/wagner-sousa/spec-kit-docker.git meu-projeto
   cd meu-projeto
   ```

2. **Renomeie o projeto**
   ```bash
   # Edite README.md com o nome do seu projeto
   # Edite .specify/memory/constitution.md com sua constituição
   ```

3. **Inicialize o Spec Kit**
   ```bash
   ./specify init . --integration opencode
   ```

4. **Comece o fluxo SDD**
   ```bash
   ./specify constitution
   ./specify specify "Minha feature"
   ```

## Referências

- [Spec Kit Documentation](https://github.com/github/spec-kit)
- [Spec Kit Extensions](https://github.com/github/spec-kit#extensions)
- [OpenCode Integration](https://github.com/opencode-ai/opencode)

## Licença

MIT
