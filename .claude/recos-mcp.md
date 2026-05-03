## Рекомендуемые MCP-серверы для banxe-infra

### Критичные (must-have)

| MCP | Зачем | Приоритет |
|---|---|---|
| **filesystem** | Безопасный доступ к `~/banxe/`, `~/banxe_backups/` | P0 |
| **ssh / shell** | Удалённое выполнение на GMKtec (192.168.0.72) | P0 |
| **github** | PR, issues, code review для banxe-infra | P0 |
| **postgres** или **clickhouse-mcp** | Прямые запросы к ClickHouse без `ssh + clickhouse-client` | P0 |

### Compliance & Security (FCA / GDPR)

| MCP | Зачем |
|---|---|
| **vault / 1password** | Хранение `gmktec_key`, Fernet-ключей, API-токенов |
| **presidio-mcp** (или wrapper над PII Proxy:8090) | Анонимизация в pipeline'ах |
| **sentry** | Алерты по падениям setup.sh / backup |

### Уже подключены (вижу в окружении)

- `Atlassian Rovo` — Jira/Confluence (тикеты IL-XXX)
- `Notion` — документация (COLLAB.md, MIROFISH)
- `Gmail` / `Google Calendar` / `Drive` — координация
- ⚠️ **MetaClaw / OpenClaw** — это ваш внутренний слой, не публичный MCP

### Не нужно

- ❌ `puppeteer / playwright-mcp` — backend-репо без UI
- ❌ `slack-mcp` — нет упоминаний Slack в стеке
- ❌ MCP из санкционных юрисдикций (RU/IR/KP/BY/SY) — запрет в CLAUDE.md

### Конкретный план

1. Открыть `~/.claude/settings.json` → добавить `filesystem` + `github` + `clickhouse`
2. Vault-MCP **до** того как класть `~/.ssh/gmktec_key` в любой автоматизированный flow
3. Presidio уже работает на :8090 — обернуть в MCP-tool для вызова из агентов

Хочешь — настрою через `/update-config` сразу `filesystem` + `github` в `settings.json`?
