## Текущее состояние

Уже есть: `ci.yml` (shellcheck + gitleaks + bash -n), `claude.yml` (только по `@claude`), `factory-guard.yml`, pre-commit, Makefile.

## Рекомендации (приоритизированы)

### P0 — закрыть пробелы PR review

**1. Auto PR Review (Claude) — без ручного триггера**
Сейчас `claude.yml` срабатывает только на `@claude`. Добавить отдельный `claude-review.yml` на `pull_request: [opened, synchronize]` через `anthropics/claude-code-action@v1` с `mode: review` и фокусом на shell-безопасность (eval, IFS, quoting, set -euo pipefail).

**2. Strict ShellCheck → SARIF в Code Scanning**
`ci.yml:23` сейчас `-S warning`. Перейти на `-S style` + загрузка SARIF через `reviewdog/action-shellcheck@v1` или `redhat-plumbers-in-action/differential-shellcheck@v5` — комментарии прямо в diff PR.

**3. BATS-тесты для `banxe-infra-setup.sh`**
Скрипт 25 KB, 5 задач, проверяется только `bash -n`. Добавить `tests/*.bats` + workflow `tests.yml` с `bats-core/bats-action@3` — мокать `ssh_gmk()`, `clickhouse-client`, проверять `log/ok/err`, идемпотентность шагов.

### P1 — gates и качество

**4. Required status checks reminder**
Workflow `branch-protection-check.yml` или README-блок: `shellcheck`, `gitleaks`, `bats`, `factory-guard` обязательны для merge в `master`.

**5. Dependabot для actions**
`.github/dependabot.yml` с `package-ecosystem: github-actions` weekly — `actions/checkout@v4` и пр. сами обновляются.

**6. CODEOWNERS**
`.github/CODEOWNERS`: `banxe-infra-setup.sh @MorielCarmi`, `*.yml @MorielCarmi` — авто-ревьюер.

### P2 — DX и observability

**7. Labeler + PR size**
`actions/labeler@v5` (по путям: `infra`, `ci`, `docs`) + `codelytv/pr-size-labeler@v1`.

**8. Gitleaks SARIF**
`ci.yml:34-37` — добавить `report_format: sarif` + `github/codeql-action/upload-sarif@v3` → секреты в Security tab.

**9. Makefile smoke-test job**
Новый job в `ci.yml`: `make quality-gate` — гарантирует, что локальный gate и CI согласованы.

**10. Concurrency cancel**
В `ci.yml`: `concurrency: { group: ci-${{ github.ref }}, cancel-in-progress: true }` — экономия минут.

## Quick wins (можно сразу)

| # | Файл | Действие |
|---|---|---|
| 1 | `.github/dependabot.yml` | новый, 5 строк |
| 2 | `.github/CODEOWNERS` | новый, 3 строки |
| 3 | `ci.yml` | добавить `concurrency` блок |
| 4 | `claude-review.yml` | новый workflow auto-review |
| 5 | `tests/setup.bats` + `tests.yml` | каркас BATS |

Хочешь — реализую п. 1–5 одним коммитом сейчас.
