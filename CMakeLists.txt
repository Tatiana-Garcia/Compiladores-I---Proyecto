cmake_minimum_required(VERSION 3.10)

project(Compiladores_I___Proyecto LANGUAGES C CXX)
include_directories(${CMAKE_SOURCE_DIR})

set(CMAKE_CXX_STANDARD 20)

# Busca flex y bison instalados
find_package(FLEX REQUIRED)
find_package(BISON REQUIRED)

# Genera parser y lexer
BISON_TARGET(MyParser parser.y ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp
        DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/parser.hpp)

FLEX_TARGET(MyScanner lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lexer.cpp)

# Asegura que se compilen en orden correcto
ADD_FLEX_BISON_DEPENDENCY(MyScanner MyParser)

# Crear ejecutable
add_executable(Compiladores_I___Proyecto
        main.cpp
        ${BISON_MyParser_OUTPUTS}
        ${FLEX_MyScanner_OUTPUTS}
        Node.cpp
        Node.h
)
