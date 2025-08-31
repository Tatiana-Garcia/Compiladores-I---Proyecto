cmake_minimum_required(VERSION 3.10)

project(Compiladores_I___Proyecto LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 20)

# Buscar flex y bison instalados en tu MSYS2
find_package(FLEX REQUIRED)
find_package(BISON REQUIRED)

# Generar parser y lexer a partir de tus archivos
BISON_TARGET(MyParser parser.y ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp
        DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/parser.hpp)

FLEX_TARGET(MyScanner lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lexer.cpp)

# Asegurar que se compilen en orden correcto
ADD_FLEX_BISON_DEPENDENCY(MyScanner MyParser)

# Crear ejecutable
add_executable(Compiladores_I___Proyecto
        main.cpp
        ${BISON_MyParser_OUTPUTS}
        ${FLEX_MyScanner_OUTPUTS}
)
