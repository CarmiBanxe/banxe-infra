# AGENTS.md — banxe-infra

**Repository:** `~/banxe-infra/`
**Version:** 1.0 | 2026-04-12
**Purpose:** BANXE infrastructure setup and operations scripts
**Stack:** bash, shellcheck, SSH (GMKtec NucBox)

---

## Core mission

Infrastructure automation for BANXE AI Bank.
Manages GMKtec NucBox production server, ClickHouse backups, MetaClaw daemon, and GDPR encryption at rest.

---

## Four-Partner Swarm

| # | Partner | Role |
|---|---------|------|
| 1 | **Claude Code** | Infrastructure architecture, script review |
| 2 | **Aider CLI** | Script executor (read-only prod review first) |

---

## Instruction hierarchy

1. Explicit user instruction (**STOP** before any prod command)
2. `CLAUDE.md` — infrastructure context
3. `AGENTS.md` — this file
4. `~/.claude/CLAUDE.md` — global defaults

---

## Infrastructure targets

| System | Host | Purpose |
|--------|------|---------|
| GMKtec NucBox | `192.168.0.72` (gmk-wsl) | Production server |
| ClickHouse | GMKtec | Audit trail DB |
| MetaClaw | Legion WSL2 | Skills daemon |
| PII Proxy | Legion WSL2 | Presidio anonymiser |

---

## Critical rules

| Rule | Details |
|------|---------|
| **QRAA protocol** | Read-only first → plan → confirm → execute |
| **SSH key** | `~/.ssh/gmktec_key` — never commit |
| **Backups** | ClickHouse backup before any migration |
| **Shellcheck** | All `.sh` files must pass `shellcheck -S warning` |

---

## Development commands

```bash
make lint               # shellcheck all .sh files
make check              # bash -n syntax check
make validate           # lint + check
make quality-gate       # full gate: lint + check + secrets scan
bash banxe-infra-setup.sh --dry-run   # preview before execution
pre-commit run --all-files
```

---

## Repository structure

```
banxe-infra/
├── banxe-infra-setup.sh    ← Master setup script (5 tasks)
├── .env.example            ← Required environment variables
├── Makefile                ← lint + check targets
└── README.md
```

---

## Definition of done

- [ ] `make quality-gate` passes (shellcheck + secrets scan)
- [ ] `pre-commit run --all-files` green
- [ ] `bash script.sh --dry-run` reviewed before prod execution
- [ ] ClickHouse backup verified before migration
