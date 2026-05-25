param(
    [string]$EngramRoot = "E:\Apps\engram",
    [switch]$Persist,
    [switch]$InstallIfMissing
)

$ErrorActionPreference = "Stop"

$binDir = Join-Path $EngramRoot "bin"
$dataDir = Join-Path $EngramRoot "data"
$engramExe = Join-Path $binDir "engram.exe"

function Add-ToPathForProcess {
    param([string]$PathToAdd)

    $parts = $env:Path -split ";" | Where-Object { $_ -ne "" }
    if ($parts -notcontains $PathToAdd) {
        $env:Path = "$PathToAdd;$env:Path"
    }
}

function Persist-UserEnv {
    param(
        [string]$PathToAdd,
        [string]$DataPath
    )

    $currentUserPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $pathParts = $currentUserPath -split ";" | Where-Object { $_ -ne "" }
    if ($pathParts -notcontains $PathToAdd) {
        [Environment]::SetEnvironmentVariable("Path", "$PathToAdd;$currentUserPath", "User")
    }

    [Environment]::SetEnvironmentVariable("ENGRAM_DATA_DIR", $DataPath, "User")
}

function Install-EngramFromSource {
    param(
        [string]$TargetBinDir,
        [string]$TargetExe
    )

    $go = Get-Command go -ErrorAction SilentlyContinue
    if (-not $go) {
        throw "Go is required to build Engram from source. Install Go 1.24+ or download a release from https://github.com/Gentleman-Programming/engram/releases."
    }

    $workDir = Join-Path $env:TEMP "engram-source-install"
    if (Test-Path $workDir) {
        Remove-Item -LiteralPath $workDir -Recurse -Force
    }

    git clone --depth 1 https://github.com/Gentleman-Programming/engram.git $workDir
    New-Item -ItemType Directory -Force -Path $TargetBinDir | Out-Null
    Push-Location $workDir
    try {
        go build -o $TargetExe .\cmd\engram
    }
    finally {
        Pop-Location
    }
}

New-Item -ItemType Directory -Force -Path $binDir, $dataDir | Out-Null

if (-not (Test-Path $engramExe)) {
    if ($InstallIfMissing) {
        Install-EngramFromSource -TargetBinDir $binDir -TargetExe $engramExe
    }
    else {
        throw "Engram was not found at $engramExe. Re-run with -InstallIfMissing to build it from https://github.com/Gentleman-Programming/engram."
    }
}

Add-ToPathForProcess -PathToAdd $binDir
$env:ENGRAM_DATA_DIR = $dataDir

if ($Persist) {
    Persist-UserEnv -PathToAdd $binDir -DataPath $dataDir
}

& $engramExe version
Write-Host "Engram ready: $engramExe"
Write-Host "ENGRAM_DATA_DIR=$dataDir"
