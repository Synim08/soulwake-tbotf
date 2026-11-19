param([string]$GodotExecutable = '')
$ErrorActionPreference = 'Stop'
$hudProject = $PSScriptRoot
if (-not $GodotExecutable) {
    $workspace = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $hudProject)))
    $GodotExecutable = Join-Path $workspace 'work\godot-tools\engine\Godot_v4.7.2-stable_win64_console.exe'
}
if (-not (Test-Path -LiteralPath $GodotExecutable)) { throw 'Indica -GodotExecutable con la ruta a Godot 4.7.2.' }
New-Item -ItemType Directory -Path (Join-Path $hudProject 'export\windows'),(Join-Path $hudProject 'export\web') -Force | Out-Null
& $GodotExecutable --headless --path $hudProject --editor --import --quit
if ($LASTEXITCODE -ne 0) { throw 'Fallo al importar la HUD.' }
& $GodotExecutable --headless --path $hudProject --script 'res://tests/test_hud.gd'
if ($LASTEXITCODE -ne 0) { throw 'Las comprobaciones de la HUD no pasaron.' }
& $GodotExecutable --headless --path $hudProject --export-release 'Web HUD'
if ($LASTEXITCODE -ne 0) { throw 'Fallo al exportar Web HUD.' }
& $GodotExecutable --headless --path $hudProject --export-release 'Windows HUD'
if ($LASTEXITCODE -ne 0) { throw 'Fallo al exportar Windows HUD.' }
Write-Output 'HUD exportada. El proyecto y las compilaciones del juego principal no se modificaron.'
