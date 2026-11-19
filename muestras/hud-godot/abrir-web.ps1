param([int]$Port = 8777)
$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath (Join-Path $PSScriptRoot 'export\web')
Write-Output "Abre http://127.0.0.1:$Port/ en el navegador. Ctrl+C detiene el servidor."
python -m http.server $Port --bind 127.0.0.1
