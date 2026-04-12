# CLAUDE.md — banxe-infra
# BANXE AI Bank — Infrastructure Automation

## Purpose

This repo manages infrastructure automation for the BANXE AI Bank stack across two machines:
- **Legion WSL2** — primary dev machine (this machine)
- **GMKtec WSL2** — secondary server (192.168.0.72)

## Script: banxe-infra-setup.sh

Executes 5 sequential tasks:
1. **MetaClaw daemon** — skills_only mode on GMKtec
2. **PII Proxy (Presidio)** — GDPR Art. 25 anonymization on port 8090
3. **Gateway migration** — copies OpenClaw config/agents to GMKtec
4. **ClickHouse backup** — full DB backup to ~/banxe_backups/
5. **Encryption at rest** — Fernet AES-128 for sensitive files (GDPR Art. 32)

## Quality gate

```bash
make quality-gate
```

Runs: ShellCheck → bash syntax check → secrets scan

## Editing rules

- NEVER hardcode IPs, passwords, or API keys — use env vars with defaults
- All SSH calls go through `ssh_gmk()` helper
- Log every step via `log()` / `ok()` / `err()` helpers
- QRAA protocol: read-only analysis first, then plan, then execute

## Prerequisites (to run setup.sh)

- SSH key at `~/.ssh/gmktec_key`
- GMKtec reachable at 192.168.0.72 (fallback: .117)
- ClickHouse + Node.js on GMKtec
