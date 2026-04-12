---
description: Run full quality gate for banxe-infra (shellcheck + syntax + secrets)
---

```bash
cd /home/mmber/banxe-infra
make quality-gate
```

Runs: ShellCheck static analysis → bash -n syntax validation → gitleaks secrets scan.
