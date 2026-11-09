param(
    [string]$GodotExecutable = '',
    [string]$TemplatesDirectory = ''
)
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$projectPath = Join-Path $projectRoot 'juego'
$workspacePath = Split-Path -Parent (Split-Path -Parent $projectRoot)
if (-not $GodotExecutable) {
    $GodotExecutable = Join-Path $workspacePath 'work\godot-tools\engine\Godot_v4.7.2-stable_win64_console.exe'
}
if (-not (Test-Path -LiteralPath $GodotExecutable)) {
    throw 'Indica -GodotExecutable con la ruta de Godot 4.7.2.'
}
$presetPath = Join-Path $projectPath 'export_presets.cfg'
$previous = [System.IO.File]::ReadAllText($presetPath)
try {
    if ($TemplatesDirectory) {
        $templateRoot = (Resolve-Path -LiteralPath $TemplatesDirectory).Path.Replace('\','/')
        $updated = $previous.Replace('../../../work/godot-tools/templates', $templateRoot)
        [System.IO.File]::WriteAllText($presetPath, $updated)
    }
    New-Item -ItemType Directory -Path (Join-Path $projectRoot 'compilaciones\web'),(Join-Path $projectRoot 'compilaciones\windows') -Force | Out-Null
    & $GodotExecutable --headless --path $projectPath --editor --import --quit
    if ($LASTEXITCODE -ne 0) { throw 'Fallo de importación.' }
    & $GodotExecutable --headless --path $projectPath --script 'res://tests/test_core.gd' -- --test-mode
    if ($LASTEXITCODE -ne 0) { throw 'Las pruebas de lógica no pasaron.' }
    & $GodotExecutable --headless --path $projectPath --script 'res://tests/test_persistence.gd' -- --test-mode
    if ($LASTEXITCODE -ne 0) { throw 'Las pruebas de persistencia no pasaron.' }
    & $GodotExecutable --headless --path $projectPath --script 'res://tests/test_builds.gd' -- --test-mode
    if ($LASTEXITCODE -ne 0) { throw 'Las pruebas de estilos y migración no pasaron.' }
    foreach ($preset in @('Web','Windows')) {
        & $GodotExecutable --headless --path $projectPath --export-release $preset
        if ($LASTEXITCODE -ne 0) { throw "Fallo al exportar $preset." }
    }
} finally {
    [System.IO.File]::WriteAllText($presetPath, $previous)
}
