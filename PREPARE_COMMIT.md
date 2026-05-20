#!/bin/bash
# Instrucciones para preparar y pusheaR el commit con Git LFS

echo "=== PREPARAR COMMIT CON GIT LFS ==="
echo ""
echo "1. Primero, instala Git LFS si no lo tienes:"
echo "   Windows (con chocolatey): choco install git-lfs"
echo "   Windows (con winget): winget install GitHub.GitLFS"
echo "   O descarga desde: https://git-lfs.github.com/"
echo ""
echo "2. Inicializa Git LFS en el repositorio (una sola vez):"
echo '   git lfs install'
echo ""
echo "3. Ahora los DLLs en SCPCBR/Dependencies/bin están listos para staging."
echo "   Haz git add y commit:"
echo ""
echo '   git add .gitattributes SCPCBR/Dependencies/bin/*.dll'
echo '   git add CMakeLists.txt copy_dlls.ps1 scripts/fetch_deps.ps1 README.md'
echo '   git add SCPCBR/Dependencies/bin/README.txt'
echo ""
echo '   git commit -m "Add vendored runtime DLLs and build configuration for GitHub'
echo '   - Copy all MinGW runtime DLLs (libstdc++, libgcc, libwinpthread) to Dependencies/bin'
echo '   - Add third-party library DLLs (GLFW, FreeType, zlib, etc.)'
echo '   - Update CMakeLists.txt to avoid hardcoded paths'
echo '   - Add scripts/fetch_deps.ps1 for automated DLL collection'
echo '   - Update copy_dlls.ps1 to detect MinGW/MSYS2 automatically'
echo '   - Configure Git LFS for binary files"'
echo ""
echo "4. Verifica que el commit está listo:"
echo '   git log -1 --stat'
echo ""
echo "5. Pushea a GitHub:"
echo '   git push origin main  # (o tu rama por defecto)'
echo ""
echo "6. (Opcional) Si los DLLs son muy pesados, considera:"
echo "   - Usar Git LFS (ya está configurado en .gitattributes)"
echo "   - O crear un GitHub Release con un ZIP de los DLLs e instrucciones"
echo ""

