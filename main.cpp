#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include "cmake-build-debug/parser.hpp" // Generado por Bison

//Funciones del Lexer y Parser generados por Bison y Flex
extern int yylex();
extern char* yytext;
extern FILE* yyin;
extern int yyparse();

using namespace std;

int main() {
    const char* file = "../RustFile.rs";
    yyin = fopen(file, "r");
    if (!yyin) {
        perror("Error al abrir archivo");
        return 1;
    }

    cout << "=== Analisis Lexico ===\n";
    int token;
    string tokenType;
    while ((token = yylex()) != 0) {
        switch(token) {
            case PRINT:  tokenType= "PRINT"; break;
            case STRING: tokenType="STRING"; break;
            default:     tokenType= "UNKNOWN"; break;
        }
        cout << "Token de Salida: " << tokenType <<" - " << token << " Texto de Entrada: " << yytext << "\n";

    }

    fseek(yyin, 0, SEEK_SET);

    cout << "=== Analisis Sintactico ===\n";
    yyparse();

    fclose(yyin);
    return 0;
}