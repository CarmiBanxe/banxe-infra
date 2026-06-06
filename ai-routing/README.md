# AI Routing (BANXE P4)

Разделение AI-плоскостей:
- **meta-plane** — облачный Claude Code и `claude-code-action` для PR-review, scaffolding, рекомендаций.
- **inference-plane** — локальный LiteLLM (`http://legion:4000/v1`) для приватных и тяжёлых задач (KYC/AML/скрининг/массовые анализы).

Запреты на облако: см. `deny_cloud_for` в `policy.yaml`. Любая AI-обработка путей под `compliance/cases/*`, `kyc/raw/*`, `secrets/*` идёт ТОЛЬКО через inference-plane.

Failover: при недоступности LiteLLM — fallback на локальный Ollama на EVO-X2.
