cmake_minimum_required(VERSION 3.20)
project(SCPCBR LANGUAGES CXX C)

# Usa C++20 y C17
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Incluye los directorios principales y dependencias
include_directories(
    ${CMAKE_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}/SCPCBR
    ${CMAKE_SOURCE_DIR}/SCPCBR/Dependencies/include
)

# Directorio de librerías
link_directories(
    ${CMAKE_SOURCE_DIR}/SCPCBR/Dependencies/lib
)

# Fuente y cabeceras
file(GLOB_RECURSE SRC_FILES
    SCPCBR/AudioEngine/*.cpp
    SCPCBR/DiscordWrapper/*.cpp
    SCPCBR/GameAssembly/*.cpp
    SCPCBR/GameManager/*.cpp
    SCPCBR/GenerationSystem/*.cpp
    SCPCBR/Launcher/*.cpp
    SCPCBR/Localization/*.cpp
    SCPCBR/MainMenu/*.cpp
    SCPCBR/Options/*.cpp
    SCPCBR/PreloadManager/*.cpp
    SCPCBR/SplashScreen/*.cpp
    SCPCBR/SteamWrapper/*.cpp
    SCPCBR/Util/*.cpp
    SCPCBR/SCPCBR.cpp
    SCPCBR/Dependencies/include/imgui/*.cpp
    SCPCBR/Dependencies/include/discord/*.cpp
    SCPCBR/Dependencies/src/glad.c
)
file(GLOB_RECURSE HEADER_FILES
    SCPCBR/AudioEngine/*.h
    SCPCBR/DiscordWrapper/*.h
    SCPCBR/GameAssembly/*.h
    SCPCBR/GameManager/*.h
    SCPCBR/GenerationSystem/*.h
    SCPCBR/Launcher/*.h
    SCPCBR/Localization/*.h
    SCPCBR/MainMenu/*.h
    SCPCBR/Options/*.h
    SCPCBR/PreloadManager/*.h
    SCPCBR/SplashScreen/*.h
    SCPCBR/SteamWrapper/*.h
    SCPCBR/Types/*.h
    SCPCBR/Util/*.h
    SCPCBR/Dependencies/include/**/*.h
    SCPCBR/Dependencies/include/**/*.hpp
)

# Recursos Windows (.rc) solo para MSVC/Win
if(WIN32 AND MSVC)
    set(RESOURCE_FILES SCPCBR/ExecutableResources/SCPCBR.rc)
endif()

add_executable(SCPCBR
    ${SRC_FILES}
    ${HEADER_FILES}
    ${RESOURCE_FILES}
)

# Preprocesador y defines
target_compile_definitions(SCPCBR PRIVATE
    _CONSOLE
    _CRT_SECURE_NO_WARNINGS
    $<$<CONFIG:Debug>:_DEBUG>
    $<$<CONFIG:Release>:NDEBUG>
    UNICODE _UNICODE
)

# Librerías del sistema y dependencias .lib (AJUSTA según necesites/hay en Dependencies/lib)
if(WIN32)
    # Añade aquí todos los .lib que uses que existan en Dependencies/lib o estén instalados globalmente
    target_link_libraries(SCPCBR
        opengl32 user32 gdi32 shell32
        glfw3dll archive freetype steam_api64
        # fmod_vc fmodL_vc - Commented out, needs MSVC ABI compatibility
        ${CMAKE_SOURCE_DIR}/SCPCBR/Dependencies/lib/discord_game_sdk.dll.lib
    )
endif()

# Copiar Assets tras la build
add_custom_command(TARGET SCPCBR POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
    "${CMAKE_SOURCE_DIR}/SCPCBR/Assets" "$<TARGET_FILE_DIR:SCPCBR>/Assets"
)

# Copiar DLLs de MinGW y dependencias de terceros si existen
set(MINGW_RUNTIME_DLLS
    libstdc++-6.dll
    libgcc_s_seh-1.dll
    libwinpthread-1.dll
)

foreach(RUNTIME_DLL IN LISTS MINGW_RUNTIME_DLLS)
    # Preferir dependencias incluidas en el repositorio (SCPCBR/Dependencies/bin)
    set(DLL_IN_REPO "${CMAKE_SOURCE_DIR}/SCPCBR/Dependencies/bin/${RUNTIME_DLL}")
    if(EXISTS "${DLL_IN_REPO}")
        add_custom_command(TARGET SCPCBR POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${DLL_IN_REPO}"
            "$<TARGET_FILE_DIR:SCPCBR>/${RUNTIME_DLL}"
        )
    else()
        # Si no está en el repo, intentar localizarlo junto al compilador usado por CMake
        if(CMAKE_C_COMPILER)
            get_filename_component(COMPILER_DIR ${CMAKE_C_COMPILER} DIRECTORY)
            set(DLL_NEXT_TO_COMPILER "${COMPILER_DIR}/${RUNTIME_DLL}")
            if(EXISTS "${DLL_NEXT_TO_COMPILER}")
                add_custom_command(TARGET SCPCBR POST_BUILD
                    COMMAND ${CMAKE_COMMAND} -E copy_if_different
                    "${DLL_NEXT_TO_COMPILER}"
                    "$<TARGET_FILE_DIR:SCPCBR>/${RUNTIME_DLL}"
                )
            else()
                # intentar una ruta relativa habitual (por si el compilador está en .../bin)
                get_filename_component(COMPILER_PARENT_DIR ${COMPILER_DIR} DIRECTORY)
                set(DLL_IN_PARENT_BIN "${COMPILER_PARENT_DIR}/bin/${RUNTIME_DLL}")
                if(EXISTS "${DLL_IN_PARENT_BIN}")
                    add_custom_command(TARGET SCPCBR POST_BUILD
                        COMMAND ${CMAKE_COMMAND} -E copy_if_different
                        "${DLL_IN_PARENT_BIN}"
                        "$<TARGET_FILE_DIR:SCPCBR>/${RUNTIME_DLL}"
                    )
                else()
                    message(STATUS "Aviso: no se encontró ${RUNTIME_DLL} ni en ${DLL_IN_REPO} ni cerca del compilador. Si vas a subir al repo, copia ${RUNTIME_DLL} a SCPCBR/Dependencies/bin o ejecuta scripts/fetch_deps.ps1")
                endif()
            endif()
        else()
            message(STATUS "Aviso: CMAKE_C_COMPILER no está definido, no se puede buscar ${RUNTIME_DLL} junto al compilador. Coloca ${RUNTIME_DLL} en SCPCBR/Dependencies/bin o ejecuta scripts/fetch_deps.ps1")
        endif()
    endif()
endforeach()

set(THIRD_PARTY_DLLS
    zlib1.dll
    libbrotlicommon.dll
    freetype.dll
    libfreetype-6.dll
    librefreetype-6.dll
    discord_game_sdk.dll
    glfw3.dll
    libwinpthread-1.dll
    libbrotlidec.dll
    libbz2-1.dll
    libharfbuzz-0.dll
    libgraphite2.dll
    libintl-8.dll
    libiconv-2.dll
    libpcre2-8-0.dll
    libpng16-16.dll
    libglib-2.0-0.dll
    steam_api64.dll
)

foreach(DLL_NAME IN LISTS THIRD_PARTY_DLLS)
    set(DLL_SOURCE "${CMAKE_SOURCE_DIR}/SCPCBR/Dependencies/bin/${DLL_NAME}")
    if(EXISTS "${DLL_SOURCE}")
        add_custom_command(TARGET SCPCBR POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${DLL_SOURCE}"
            "$<TARGET_FILE_DIR:SCPCBR>/${DLL_NAME}"
        )
    endif()
endforeach()

