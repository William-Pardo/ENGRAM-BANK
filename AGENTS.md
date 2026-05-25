# ENGRAM-BANK Agent Instructions

This repository is the central Git-backed Engram memory bank for William Pardo.

## Required Behavior

When an AI agent reads this repo, it must treat it as the synchronization hub for Engram memories across multiple projects.

Before meaningful work:

1. Ensure Engram is available.
2. Prefer the local installation at `E:\Apps\engram`.
3. If that installation is missing, ask to install/build Engram from `https://github.com/Gentleman-Programming/engram`.
4. Import existing bank memories with `.\scripts\Sync-EngramBank.ps1 -Import`.

After meaningful work in any project:

1. Save important decisions/learnings to Engram through MCP when available.
2. Return to this repo.
3. Run `.\scripts\Sync-EngramBank.ps1 -All`.
4. Commit and push `.engram/` changes when the user wants the bank updated on GitHub.

## Local Engram Contract

Preferred Windows layout:

```text
E:\Apps\engram\bin\engram.exe
E:\Apps\engram\data\engram.db
```

Use these process environment values when running Engram from scripts:

```text
PATH includes E:\Apps\engram\bin
ENGRAM_DATA_DIR=E:\Apps\engram\data
```

Never commit the live SQLite database. Only commit exported sync chunks under this repo's `.engram/` directory.

## Cross-Project Policy

This bank may contain memories from multiple projects. Use:

```powershell
engram sync --all
```

from the ENGRAM-BANK repo to export all local Engram project memories into the bank.

Use:

```powershell
engram sync --import
```

from the ENGRAM-BANK repo to import the bank into the current PC's local Engram database.
