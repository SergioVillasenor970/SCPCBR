Coloca aquí las DLLs de 64 bits que deben copiarse junto a `SCPCBR.exe`:

- `freetype.dll` (MSYS2 suele exponer `libfreetype-6.dll`; aquí se renombra a `freetype.dll`)
- `libfreetype-6.dll` (nombre real que expone MSYS2 para FreeType)
- `discord_game_sdk.dll`
- `glfw3.dll`
- `steam_api64.dll`
- `zlib1.dll`
- `libbrotlicommon.dll`
- `libbrotlidec.dll`
- `libbz2-1.dll`
- `libharfbuzz-0.dll`
- `libgraphite2.dll`
- `libintl-8.dll`
- `libiconv-2.dll`
- `libpcre2-8-0.dll`
- `libpng16-16.dll`
- `libglib-2.0-0.dll`

Estas DLLs deben ser compatibles con la build MinGW x64 usada por el proyecto.
El CMakeLists.txt y copy_dlls.ps1 las copiarán automáticamente al directorio de salida si están presentes.

Para ayudar a recopilar estas DLLs sin rutas hardcodeadas, puedes ejecutar desde la raíz del repositorio:

	powershell -ExecutionPolicy Bypass -File scripts/fetch_deps.ps1

El script intentará localizar una instalación de MSYS2 (`C:\msys64\mingw64\bin`) o un compilador `g++` en PATH
y copiará las DLLs a este directorio `SCPCBR/Dependencies/bin`. Una vez ahí, CMake las copiará automáticamente
al construir el proyecto.

