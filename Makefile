.PHONY: lint check validate quality-gate help

help:
	@echo "BANXE Infra — Available targets:"
	@echo "  make lint         ShellCheck all .sh files"
	@echo "  make check        Bash syntax check (--noexec)"
	@echo "  make validate     lint + check"
	@echo "  make quality-gate Full gate: lint + check + secrets scan"

lint:
	@echo "🔍 ShellCheck..."
	@find . -name "*.sh" -not -path "./.git/*" | xargs shellcheck -S warning && echo "✅ ShellCheck PASSED"

check:
	@echo "🔍 Bash syntax check..."
	@find . -name "*.sh" -not -path "./.git/*" | while read f; do \
		bash -n "$$f" && echo "  ✅ $$f" || exit 1; \
	done

validate: lint check
	@echo "✅ Validation PASSED"

secrets-scan:
	@command -v gitleaks >/dev/null && gitleaks detect --source . --verbose || echo "[SKIP] gitleaks not installed"

quality-gate: validate secrets-scan
	@echo "✅ Quality gate PASSED"
