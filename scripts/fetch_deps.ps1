# Script para recopilar las DLL necesarias y colocarlas en SCPCBR/Dependencies/bin
# Detecta MSYS2 (C:\msys64\mingw64\bin) o la carpeta del compilador (g++.exe) en PATH
# y copia las DLLs listadas hacia el repositorio para que CMake las copie al directorio de salida.

param()

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$repoRoot = Resolve-Path "$scriptDir/.."
$depsBin = Join-Path $repoRoot "SCPCBR/Dependencies/bin"

if (-not (Test-Path $depsBin)) {
    Write-Host "Creando carpeta de dependencias: $depsBin"
    New-Item -ItemType Directory -Path $depsBin -Force | Out-Null
}

# Lista de DLLs que queremos reunir
$dlls = @(
    'libstdc++-6.dll',
    'libgcc_s_seh-1.dll',
    'libwinpthread-1.dll',
    'zlib1.dll',
    'libbrotlicommon.dll',
    'libbrotlidec.dll',
    'libbz2-1.dll',
    'libharfbuzz-0.dll',
    'libpng16-16.dll',
    'libfreetype-6.dll',
    'freetype.dll',
    'librefreetype-6.dll',
    'libglib-2.0-0.dll',
    'libgraphite2.dll',
    'libintl-8.dll',
    'libpcre2-8-0.dll',
    'libiconv-2.dll',
    'glfw3.dll',
    'discord_game_sdk.dll',
    'steam_api64.dll'
)

# Posibles fuentes donde buscar (ordenadas por preferencia)
$sources = @()
if (Test-Path 'C:\msys64\mingw64\bin') {
    $sources += 'C:\msys64\mingw64\bin'
}

# Intentar detectar g++/gcc en PATH
try {
    $gpp = Get-Command g++.exe -ErrorAction Stop
    if ($gpp -and $gpp.Path) {
        $compilerDir = Split-Path -Parent $gpp.Path
        $sources += $compilerDir
    }
} catch {
    # no encontrado
}

# También intentar detectar gcc/g++ instalados junto con CLion (no hardcodeamos una ruta específica pero
# si el binario está en PATH lo encontraremos arriba). Si no hay fuentes, avisa al usuario.

if ($sources.Count -eq 0) {
    Write-Warning "No se han encontrado fuentes automáticas (MSYS2 ni g++ en PATH). Instala MSYS2 o añade MinGW al PATH."
    Write-Host "Sugerencia: instala MSYS2 y ejecuta: pacman -S --needed mingw-w64-x86_64-glfw mingw-w64-x86_64-freetype mingw-w64-x86_64-zlib"
}

function Copy-From-Sources($dllName) {
    foreach ($src in $sources) {
        $candidate = Join-Path $src $dllName
        if (Test-Path $candidate) {
            Copy-Item -Path $candidate -Destination $depsBin -Force
            Write-Host "Copiado: $dllName desde $src"
            return $true
        }
    }
    return $false
}

foreach ($dll in $dlls) {
    # Si ya está en el repo, no hacer nada
    $target = Join-Path $depsBin $dll
    if (Test-Path $target) {
        Write-Host "$dll ya existe en $depsBin"
        continue
    }

    $ok = Copy-From-Sources $dll
    if (-not $ok) {
        Write-Warning "No se encontró $dll en las fuentes automáticas. Puedes colocarlo manualmente en $depsBin."
    }
}

Write-Host "Resumen: contenido de $depsBin"
Get-ChildItem -Path $depsBin | ForEach-Object { Write-Host $_.Name }

Write-Host "Cuando tengas los DLL en SCPCBR/Dependencies/bin, CMake los copiará automáticamente al construir."
