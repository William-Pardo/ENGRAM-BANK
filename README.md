# ENGRAM-BANK

Banco central de memorias Engram para los proyectos de William Pardo.

Este repo no reemplaza a Engram. Engram es el programa y la base local. Este repo guarda exportaciones sincronizables para poder mover memorias entre PCs usando GitHub.

## Modelo

```text
Proyecto A / Proyecto B / Proyecto C
        -> Engram local
        -> ENGRAM-BANK/.engram/chunks
        -> GitHub
        -> otra PC importa desde ENGRAM-BANK
```

En esta PC se usa esta instalacion local preferida:

```text
E:\Apps\engram\bin\engram.exe
E:\Apps\engram\data\engram.db
```

Si esa ruta no existe, los scripts intentan instalar Engram desde:

```text
https://github.com/Gentleman-Programming/engram
```

## Primer uso en esta PC

Desde este repo:

```powershell
.\scripts\Ensure-Engram.ps1 -Persist
.\scripts\Sync-EngramBank.ps1 -All -Push
```

`-Persist` agrega `E:\Apps\engram\bin` al PATH de usuario y define `ENGRAM_DATA_DIR=E:\Apps\engram\data`.

## Importar el banco en otra PC

```powershell
git clone https://github.com/William-Pardo/ENGRAM-BANK.git
cd ENGRAM-BANK
.\scripts\Ensure-Engram.ps1 -Persist
git pull
.\scripts\Sync-EngramBank.ps1 -Import
```

## Sincronizar despues de trabajar

Cuando termines una sesion en cualquier proyecto:

```powershell
cd E:\Apps\ENGRAM-BANK
.\scripts\Sync-EngramBank.ps1 -All -Push
```

En otra PC, antes de trabajar:

```powershell
cd ENGRAM-BANK
git pull
.\scripts\Sync-EngramBank.ps1 -Import
```

## Instalar instruccion en un proyecto

Para que un proyecto tenga una instruccion local que le recuerde al agente usar este banco:

```powershell
.\scripts\Install-ProjectInstruction.ps1 -ProjectPath E:\Apps\Tudojang
```

Esto copia una instruccion a:

```text
<proyecto>\AGENTS.md
```

Si el proyecto ya tiene `AGENTS.md`, el script agrega una seccion sin borrar el contenido existente.

## Reglas importantes

- No subir `E:\Apps\engram\data\engram.db` a GitHub.
- Subir solo exportaciones `.engram/chunks/*.jsonl.gz` y `.engram/manifest.json`.
- Usar `engram sync --all` desde este repo para exportar memoria de multiples proyectos.
- Usar `engram sync --import` desde este repo para cargar el banco en una PC nueva.
