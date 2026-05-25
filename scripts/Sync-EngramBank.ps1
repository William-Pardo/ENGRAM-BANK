param(
    [switch]$All,
    [switch]$Import,
    [switch]$Push,
    [string]$Message = "sync engram bank"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$ensure = Join-Path $PSScriptRoot "Ensure-Engram.ps1"

& $ensure

Push-Location $repoRoot
try {
    if ($Import) {
        & engram sync --import
    }
    elseif ($All) {
        & engram sync --all
    }
    else {
        & engram sync
    }

    & engram sync --status

    if ($Push) {
        git add .engram
        $status = git status --short
        if ($status) {
            git commit -m $Message
            git push
        }
        else {
            Write-Host "No Engram bank changes to commit."
        }
    }
}
finally {
    Pop-Location
}
