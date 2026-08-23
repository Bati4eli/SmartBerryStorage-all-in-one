# CLAUDE.md (workspace root)

Workspace SmartBerryStorage: три независимых git-репозитория.
- `MyCloud-Backend` — многомодульный backend (Java + Groovy + Python, Gradle, gRPC, PostgreSQL).
- `MyCloud-AndroidClient` — Android-клиент на Java, общается с сервером по gRPC.
- `MyCloud-WebClient` — web-клиент (Angular + Material 3, PWA), ходит к серверу через gRPC-Web и REST.

Все правила работы агента — в AGENTS.md (единый источник правил для Codex и Claude):
@AGENTS.md

Правила конкретного репозитория лежат в его AGENTS.md и подключаются через его CLAUDE.md.
