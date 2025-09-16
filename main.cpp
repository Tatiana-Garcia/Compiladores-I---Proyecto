#include <iostream>
#include <fstream>
#include <string>
#include "Node.h"
#include "cmake-build-debug/parser.hpp" // Generado por Bison

//Funciones del Lexer y Parser generados por Bison y Flex
extern int yylex();
extern char* yytext;
extern FILE* yyin;
extern int yyparse();
extern Node* root;

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
            case PRINT:           tokenType = "PRINT"; break;
            case LESS:            tokenType = "LESS"; break;
            case GREATER:         tokenType = "GREATER"; break;
            case EQUAL:           tokenType = "EQUAL"; break;
            case NOTEQUAL:       tokenType = "NOT_EQUAL"; break;
            case FUNCTION:       tokenType = "FUNCTION"; break;
            case STRING:          tokenType = "STRING"; break;
            case RETURN:          tokenType = "RETURN"; break;
            case LBRACE:    tokenType = "LBRACE"; break;
            case RBRACE:    tokenType = "RBRACE"; break;
            case LPARENTHESES:    tokenType = "LPAREN"; break;
            case RPARENTHESES:    tokenType = "RPAREN"; break;
            case SEMICOLON:       tokenType = "SEMICOLON"; break;
            case LET:             tokenType = "LET"; break;
            case IDENTIFIER:      tokenType = "IDENTIFIER"; break;
            case ASSIGN:          tokenType = "ASSIGN"; break;
            case MAIN:            tokenType = "MAIN"; break;
            case COMMA:            tokenType = "COMMA"; break;
            case PLUS:             tokenType = "PLUS"; break;
            case MINUS:            tokenType = "MINUS"; break;
            case COLON:            tokenType = "COLON"; break;
            case I32:              tokenType = "I32"; break;
            case ARROW:            tokenType = "ARROW"; break;
            case INTEGER:          tokenType = "INTEGER"; break;
            case IF:               tokenType = "IF"; break;
            case ELSE:             tokenType = "ELSE"; break;
            default:     tokenType= "UNKNOWN"; break;
        }
        cout << "Token de Salida: " << tokenType <<" - " << token << " Texto de Entrada: " << yytext << "\n";
    }

    fseek(yyin, 0, SEEK_SET);

    cout << "=== Analisis Sintactico ===\n";

    if (yyparse() == 0) {
        cout << "Analisis sintactico exitoso: Todo coincide con las reglas del Lenguaje Rust\n";
        if (root) root->print(0);
    } else {
        cout<< "Error sintactico encontrado, no coincide con las reglas del Lenguaje Rust.\n";
    }

    fclose(yyin);
    return 0;
}