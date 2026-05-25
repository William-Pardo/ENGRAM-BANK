param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectPath,

    [string]$BankPath = "E:\Apps\ENGRAM-BANK"
)

$ErrorActionPreference = "Stop"

$resolvedProject = Resolve-Path -LiteralPath $ProjectPath
$agentFile = Join-Path $resolvedProject "AGENTS.md"
$templateFile = Join-Path $BankPath "templates\ENGRAM-BANK-INSTRUCTIONS.md"

if (-not (Test-Path $templateFile)) {
    throw "Template not found: $templateFile"
}

$template = Get-Content -LiteralPath $templateFile -Raw
$sectionStart = "<!-- ENGRAM-BANK:START -->"
$sectionEnd = "<!-- ENGRAM-BANK:END -->"
$section = @"

$sectionStart
$template
$sectionEnd
"@

if (Test-Path $agentFile) {
    $current = Get-Content -LiteralPath $agentFile -Raw
    if ($current.Contains($sectionStart)) {
        $pattern = [regex]::Escape($sectionStart) + ".*?" + [regex]::Escape($sectionEnd)
        $updated = [regex]::Replace($current, $pattern, ($sectionStart + "`r`n" + $template + "`r`n" + $sectionEnd), [Text.RegularExpressions.RegexOptions]::Singleline)
        Set-Content -LiteralPath $agentFile -Value $updated -Encoding UTF8
    }
    else {
        Add-Content -LiteralPath $agentFile -Value $section -Encoding UTF8
    }
}
else {
    Set-Content -LiteralPath $agentFile -Value ($template + "`r`n") -Encoding UTF8
}

Write-Host "Installed Engram Bank instructions in $agentFile"
