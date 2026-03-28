# Banxe AI Bank — Infrastructure Setup

Automated sequential setup for all critical infrastructure tasks.

## Usage

```bash
# From Legion WSL2:
bash banxe-infra-setup.sh
```

## Tasks (executed sequentially)

1. **MetaClaw daemon** — skills_only mode, OpenClaw extension + systemd service
2. **PII Proxy (Presidio)** — installed on GMKtec, port 8090, GDPR Art. 25
3. **Gateway migration** — OpenClaw config + agents + credentials copied to GMKtec
4. **ClickHouse backup** — full database backup, compressed, downloaded to Legion
5. **Encryption at rest** — Fernet (AES-128) for sensitive files, GDPR Art. 32

## Prerequisites

- SSH access to GMKtec (`ssh banxe@192.168.0.72`)
- OpenClaw running on Legion
- ClickHouse running on GMKtec
- Node.js + npm on GMKtec (for OpenClaw)

## Security Score Target

Before: 2/10 → After: 5/10 (estimated)
