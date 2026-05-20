# Copiar librerías y DLLs necesarias al directorio de build
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$repoRoot = Resolve-Path "$scriptDir"
$buildDir = Join-Path $repoRoot 'cmake-build-debug'
$depsBinDir = Join-Path $repoRoot 'SCPCBR/Dependencies/bin'

# Intentar localizar una carpeta MinGW/MSYS2 sin rutas hardcodeadas
$mingwBin = $null
if (Test-Path 'C:\msys64\mingw64\bin') { $mingwBin = 'C:\msys64\mingw64\bin' }
else {
	try {
		$gpp = Get-Command g++.exe -ErrorAction Stop
		if ($gpp -and $gpp.Path) { $mingwBin = Split-Path -Parent $gpp.Path }
	} catch {
		# no encontrado
	}
}

function Copy-IfExists {
	param(
		[Parameter(Mandatory = $true)][string]$Source,
		[Parameter(Mandatory = $true)][string]$Destination
	)

	if (Test-Path $Source) {
		Copy-Item $Source $Destination -Force
		Write-Host "Copiado: $Source"
	}
	else {
		Write-Warning "No existe: $Source"
	}
}

# DLLs de MinGW requeridas por el ejecutable
if ($mingwBin) {
	Copy-IfExists "$mingwBin\libstdc++-6.dll" "$buildDir\"
	Copy-IfExists "$mingwBin\libgcc_s_seh-1.dll" "$buildDir\"
	Copy-IfExists "$mingwBin\libwinpthread-1.dll" "$buildDir\"
} else {
	Write-Warning "No se encontró carpeta MinGW/MSYS2 automáticamente. Si faltan runtimes (libstdc++-6.dll, libgcc_s_seh-1.dll, libwinpthread-1.dll) colócalos en $depsBinDir"
}

# DLLs de terceros que deben ir junto al .exe
Copy-IfExists "$depsBinDir\zlib1.dll" "$buildDir\"
Copy-IfExists "$depsBinDir\libbrotlicommon.dll" "$buildDir\"
Copy-IfExists "$depsBinDir\freetype.dll" "$buildDir\"
Copy-IfExists "$depsBinDir\libfreetype-6.dll" "$buildDir\"
Copy-IfExists "$depsBinDir\librefreetype-6.dll" "$buildDir\"
Copy-IfExists "$depsBinDir\discord_game_sdk.dll" "$buildDir\"
Copy-IfExists "$depsBinDir\glfw3.dll" "$buildDir\"
Copy-IfExists "$depsBinDir\libbrotlidec.dll" "$buildDir\"
Copy-IfExists "$depsBinDir\libbz2-1.dll" "$buildDir\"
Copy-IfExists "$depsBinDir\libharfbuzz-0.dll" "$buildDir\"
Copy-IfExists "$depsBinDir\libgraphite2.dll" "$buildDir\"
Copy-IfExists "$depsBinDir\libintl-8.dll" "$buildDir\"
Copy-IfExists "$depsBinDir\libiconv-2.dll" "$buildDir\"
Copy-IfExists "$depsBinDir\libpcre2-8-0.dll" "$buildDir\"
Copy-IfExists "$depsBinDir\libpng16-16.dll" "$buildDir\"
Copy-IfExists "$depsBinDir\libglib-2.0-0.dll" "$buildDir\"
Copy-IfExists "$depsBinDir\steam_api64.dll" "$buildDir\"

Write-Host "Proceso de copia finalizado"
