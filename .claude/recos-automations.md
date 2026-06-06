## Рекомендации по автоматизациям — banxe-infra

**Профиль:** Bash-инфра, shellcheck + pre-commit, Makefile quality-gate, 3 GitHub workflow (ci/claude/factory-guard), удалённые SSH-операции на GMKtec, чувствительные файлы (.env, SSH-ключи, GDPR).

---

### ⚡ Hooks (приоритет №1 — у вас уже есть quality-gate, его надо «прибить» к Edit)

**1. PreToolUse — блокировать правки секретов и ключей**
- **Зачем:** `.env`, `~/.ssh/gmktec_key`, `secrets/*` уже в `deny_paths`, но это soft-rule. Hook жёстко блокирует Edit/Write до того, как Claude к ним прикоснётся.
- **Где:** `.claude/settings.json` → `hooks.PreToolUse` с matcher по path-glob `**/.env*`, `**/secrets/**`, `**/*.pem`, `**/id_*`, `**/gmktec_key*`.

**2. PostToolUse — auto-shellcheck при правке `*.sh`**
- **Зачем:** quality-gate сейчас запускается вручную через `make`. Перевод в hook убирает разрыв между «отредактировал» и «проверил» — критично для скриптов с `ssh_gmk()`, где опечатка = выстрел в прод.
- **Команда:** `shellcheck -S warning "$CLAUDE_FILE_PATH" && bash -n "$CLAUDE_FILE_PATH"`.

---

### 🤖 Subagents

**1. `shell-safety-reviewer`**
- **Зачем:** репо целиком — bash, с SSH-вызовами на удалённую машину и работой с шифрованием (Fernet). Нужен агент, который ловит: unquoted vars, `eval`, hardcoded IP/creds, отсутствие `set -euo pipefail`, нарушения «всё через `ssh_gmk()`».
- **Где:** `.claude/agents/shell-safety-reviewer.md`, инструменты: Read, Grep, Bash(shellcheck:*).

**2. `gdpr-secrets-auditor`**
- **Зачем:** GDPR Art.25/32 заявлены в CLAUDE.md, есть PII Proxy и Fernet. Агент сверяет diff с инвариантами: ключи не в коммитах, чувствительные пути не логируются открыто, шифрование не обходится.

---

### 🎯 Skills (custom)

**1. `gmk-remote-runbook`** (user-only, `disable-model-invocation: true`)
- **Зачем:** все 5 задач setup.sh — удалённые. Скилл-обёртка для идемпотентного запуска одной задачи с dry-run, логом и rollback-инструкцией. Снимает повторяющийся ритуал «ssh → check → run → verify».
- **Инвокация:** `/gmk-remote-runbook task=2` (PII Proxy), и т.д.

**2. `infra-rollback-plan`** (Both)
- **Зачем:** перед каждым merge в master по инфра-скриптам нужен явный план отката (особенно для backup/encryption). Скилл генерирует план из diff: какие файлы тронуты, как откатить, чем валидировать.

---

### 🔌 MCP Servers

**1. GitHub MCP**
- **Зачем:** 3 активных workflow (включая `factory-guard`) + `/banxe-review-pr` уже в командах. MCP даёт Claude нативный доступ к статусам runs, аннотациям, PR-комментариям без `gh` через Bash.
- **Установка:** `claude mcp add github`.

**2. context7** (опционально)
- **Зачем:** Presidio, Fernet, ClickHouse-CLI — внешние тулзы с активными API. Live-докой избавит от устаревших флагов в скриптах.

---

### 🧩 Плагин

**`hookify`** — упрощает написание hook-конфигов для пунктов выше; пригодится один раз и останется как референс для новых правил.

---

**Что дальше:** скажи, что разворачиваем первым — я могу сразу написать конфиги (hook на secrets + PostToolUse shellcheck — это 15 минут и закрывает 80% риска). Запросить больше вариантов по любой категории — тоже ок.
