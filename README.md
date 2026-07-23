# Spec Kit Docker Template

[![Spec Kit](https://img.shields.io/badge/Spec%20Kit-0.12.5-blue)](https://github.com/github/spec-kit)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)
[![OpenCode](https://img.shields.io/badge/OpenCode-Integration-purple)](https://github.com/opencode-ai/opencode)

> Template Docker para [Spec Kit](https://github.com/github/spec-kit) — desenvolvimento orientado por especificações (SDD) com tudo configurado e pronto para usar.

## Índice

- [Sobre](#sobre)
- [Pré-requisitos](#pré-requisitos)
- [Início Rápido](#início-rápido)
- [Fluxo de Trabalho](#fluxo-de-trabalho)
- [Comandos](#comandos)
- [Como Usar como Template](#como-usar-como-template)
- [Licença](#licença)

## Sobre

Este repositório é um template Docker com [Spec Kit](https://github.com/github/spec-kit) e todas as extensões oficiais configuradas. Use como base para projetos que seguem Spec-Driven Development com AI Coding Agents (OpenCode, Copilot, etc.).

### Tecnologias

- **Docker** — ambiente isolado e reproduzível
- **Spec Kit 0.12.5** — core do SDD
- **OpenCode** — integração com AI coding agent
- **9 extensões** — Git, Review, Verify, Sync, Bugfix, Refine, Doctor, Agent-Context, Lifecycle

## Pré-requisitos

- Docker e Docker Compose instalados
- Git
- AI Coding Agent (opencode, copilot, etc.)

## Início Rápido

```bash
# 1. Build da imagem
docker compose -f docker-compose.specify.yml build

# 2. Inicializar projeto
./specify init . --integration opencode

# 3. Iniciar fluxo SDD
./specify constitution
./specify specify "Descrição da feature"
```

## Fluxo de Trabalho

### Ciclo Principal SDD

```mermaid
graph TD
    A[constitution] -->|Define princípios| B[specify]
    B -->|Define requisitos| C[plan]
    C -->|Plano técnico| D[tasks]
    D -->|Gera tarefas| E[implement]
    E -->|Implementa| F{Review & Verify}
    F -->|Aprovado| G[PR / Deploy]
    F -->|Reprovado| E
```

### Fluxo com Hooks (before → comando → after)

Cada comando core é envolvido por hooks que executam antes e depois automaticamente:

```mermaid
graph LR
    A[before_constitution] --> B[constitution]
    B --> C[after_constitution]
    C --> D[before_specify]
    D --> E[specify]
    E --> F[after_specify]
    F --> G[before_plan]
    G --> H[plan]
    H --> I[after_plan]
    I --> J[before_tasks]
    J --> K[tasks]
    K --> L[after_tasks]
    L --> M[before_implement]
    M --> N[implement]
    N --> O[after_implement]
```

Os hooks `before_*` preparam o ambiente (git branches, contexto). Os hooks `after_*` executam verificações (review, verify, sync, commit, etc.).

### Extensões Instaladas

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

    subgraph "Governance"
        J[Lifecycle]
    end

    subgraph "Diagnostics"
        I[Doctor]
    end

    A -->|Atualiza contexto| L[Coding Agent]
    B -->|Gerencia branches| M[Git Repository]
    C -->|Review código| N[Code Quality]
    D -->|Valida implementação| O[Spec Alignment]
    E -->|Detecta phantom tasks| P[Task Completion]
    F -->|Detecta drift spec-código| Q[Spec Drift]
    G -->|Workflow de bugfix| R[Bugfix]
    H -->|Refina especificações| S[Specification]
    J -->|Bloqueia/libera comandos| L
    I -->|Diagnóstico do projeto| T[Project Health]
```

### Extensão Git — Branch Management & Auto-Commit

```mermaid
graph LR
    A[before_constitution] -->|git initialize| B[Repo iniciado]
    C[before_specify] -->|git feature| D[Branch criada]
    E[before_clarify] -->|git commit| F[Commit automático]
    G[before_plan] -->|git commit| F
    H[before_tasks] -->|git commit| F
    I[before_implement] -->|git commit| F
    J[after_constitution] -->|git commit| F
    K[after_specify] -->|git commit| F
    L[after_plan] -->|git commit| F
    M[after_tasks] -->|git commit| F
    N[after_implement] -->|git commit| F
```

### Extensão Review — Code Review Automático

Disparado em `after_implement`:

```mermaid
graph TD
    A[after_implement] --> B[review.run]
    B --> C[Revisa código, testes, tipos, erros]
    C --> D{Aprovado?}
    D -->|Sim| E[Prossegue]
    D -->|Não| F[Corrigir issues]
    F --> B
```

### Extensão Verify — Validação vs Specs

Disparado em `after_implement`:

```mermaid
graph TD
    A[after_implement] --> B[verify.run]
    B --> C[Valida implementação vs spec.md / plan.md / tasks.md]
    C --> D{Alinhado?}
    D -->|Sim| E[Implementação válida]
    D -->|Não| F[Relatório de desvios]
    F --> G[Corrigir]
    G --> B
```

### Extensão Sync — Detecção de Drift

Disparado em `after_implement`:

```mermaid
graph TD
    A[after_implement] --> B[sync.analyze]
    B --> C{Drift detectado?}
    C -->|Não| D[Tudo ok]
    C -->|Sim| E[sync.propose]
    E --> F{Aprovar resolução?}
    F -->|Sim| G[sync.apply]
    F -->|Não| H[Revisar manualmente]
    G --> I[Specs atualizados]
```

### Extensão Bugfix — Workflow de Correção

```mermaid
graph TD
    A[Identificar bug] --> B[bugfix.report]
    B --> C[Rastreia artefatos spec]
    C --> D[bugfix.patch]
    D --> E[Atualiza spec / plan / tasks]
    E --> F[after_implement]
    F --> G[bugfix.verify]
    G --> H{Consistente?}
    H -->|Sim| I[Bugfix completo]
    H -->|Não| J[Corrigir artefatos]
    J --> D
```

### Extensão Refine — Refinamento de Especificações

```mermaid
graph LR
    A[Nova requisição] --> B[refine.update]
    B --> C[Atualiza spec.md]
    C --> D[refine.propagate]
    D --> E[Atualiza plan.md]
    D --> F[Atualiza tasks.md]
    G[after_specify] --> H[refine.status]
    H --> I{Spec desatualizada?}
    I -->|Sim| J[refine.diff]
    I -->|Não| K[Tudo sincronizado]
```

### Extensão Lifecycle — Gerenciamento de Fases

```mermaid
graph LR
    A[Fase active] --> B[Todos os comandos disponíveis]
    B --> C{Spec finalizada?}
    C -->|Não| B
    C -->|Sim| D[lifecycle.lock]
    D --> E[Fase locked]
    E --> F[Core SDD bloqueado]
    E --> G[refine.* liberado]
    E --> G
    E --> H[bugfix.* liberado]
    F --> I{Precisa alterar?}
    I -->|Mudança controlada| G
    I -->|Bug| H
    I -->|Mudança estrutural| J[lifecycle.unlock]
    J --> B
```

Controla o ciclo de vida da especificação. Quando ativa (`locked`), bloqueia comandos de escrita direta (`specify`, `clarify`, `plan`, `tasks`, `checklist`, `analyze`) e permite apenas caminhos controlados (`refine.*`, `bugfix.*`).

## Comandos

### Comandos Core — Ciclo SDD

| Comando | Descrição | Quando usar |
|---------|-----------|-------------|
| `./specify constitution` | Define princípios e constraints do projeto | Antes de qualquer especificação |
| `./specify specify "..."` | Define requisitos de uma feature | Após constitution, antes de plan |
| `./specify plan` | Cria plano técnico detalhado | Após specify, antes de tasks |
| `./specify tasks` | Gera breakdown de tarefas | Após plan, antes de implement |
| `./specify implement` | Executa implementação orientada por specs | Após tasks |
| `./specify clarify` | Esclarece requisitos ambíguos | Durante specify ou implement |
| `./specify analyze` | Analisa o projeto e sugere direções | A qualquer momento |
| `./specify checklist` | Gera checklist de verificação | Antes de PR/deploy |
| `./specify converge` | Converge artefatos spec desatualizados | Quando houver drift |
| `./specify taskstoissues` | Converte tasks em issues do GitHub | Após tasks, para acompanhamento |

### Comandos das Extensões

| Extensão | Comando | Descrição | Disparo automático |
|----------|---------|-----------|--------------------|
| **Git** | `speckit.git.initialize` | Inicializa repositório git | `before_constitution` |
| | `speckit.git.feature` | Cria branch para feature | `before_specify` |
| | `speckit.git.commit` | Auto-commit do progresso | `before_*` e `after_*` |
| | `speckit.git.validate` | Valida estado da branch | Manual |
| | `speckit.git.remote` | Detecta remote configurado | Manual |
| **Agent-Context** | `speckit.agent-context.update` | Atualiza contexto do agente | `after_*` |
| **Review** | `speckit.review.run` | Review completo (código, testes, tipos, erros, simplificação) | `after_implement` |
| | `speckit.review.code` | Apenas code quality | Manual |
| | `speckit.review.comments` | Análise de comentários | Manual |
| | `speckit.review.tests` | Cobertura de testes | Manual |
| | `speckit.review.errors` | Error handling | Manual |
| | `speckit.review.types` | Type design | Manual |
| | `speckit.review.simplify` | Simplificação de código | Manual |
| **Verify** | `speckit.verify.run` | Valida implementação vs spec/plan/tasks | `after_implement` |
| **Verify-Tasks** | `speckit.verify-tasks.run` | Detecta phantom tasks (tasks implementadas sem especificação) | `after_implement` |
| **Sync** | `speckit.sync.analyze` | Detecta drift entre spec e código | `after_implement` |
| | `speckit.sync.propose` | Propõe resoluções para drift | Manual |
| | `speckit.sync.apply` | Aplica resoluções aprovadas | Manual |
| | `speckit.sync.conflicts` | Detecta conflitos entre artefatos | Manual |
| | `speckit.sync.backfill` | Gera spec a partir de código existente | Manual |
| **Bugfix** | `speckit.bugfix.report` | Reporta bug e rastreia artefatos | Após identificar bug |
| | `speckit.bugfix.patch` | Aplica patch e atualiza specs | Manual |
| | `speckit.bugfix.verify` | Verifica consistência pós-patch | `after_implement` |
| **Refine** | `speckit.refine.update` | Atualiza spec.md com nova requisição | Após nova solicitação |
| | `speckit.refine.propagate` | Propaga mudanças para plan/tasks | Manual |
| | `speckit.refine.diff` | Mostra diferenças entre artefatos | Manual |
| | `speckit.refine.status` | Verifica se specs estão sincronizadas | `after_specify`, `after_plan` |
| **Doctor** | `speckit.doctor.check` | Diagnóstico completo do projeto | Manual |
| **Lifecycle** | `speckit.lifecycle.lock` | Bloqueia comandos de escrita após spec finalizada | Manual |
| | `speckit.lifecycle.unlock` | Reabilita todos os comandos | Manual |
| | `speckit.lifecycle.status` | Mostra fase atual e disponibilidade de comandos | Manual |

## Como Usar como Template

```bash
# 1. Clone
git clone https://github.com/wagner-sousa/spec-kit-docker.git meu-projeto
cd meu-projeto

# 2. Renomeie (README, .specify/memory/constitution.md)

# 3. Inicialize o Spec Kit
./specify init . --integration opencode

# 4. Comece o fluxo SDD
./specify constitution
./specify specify "Minha primeira feature"
```

## Licença

MIT. Veja [LICENSE](LICENSE).
