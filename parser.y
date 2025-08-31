%{
#include <stdio.h>
#include <stdlib.h>

// Prototipos para que Bison conozca estas funciones:
int yylex(void);
void yyerror(const char *s);
%}

// Le decimos que el tipo de los valores es char*
%union {
    char* str;
}

%token <str> PRINT STRING

%%

program:
      PRINT STRING { printf("Print: %s\n", $2); }
    ;

%%

// Definición de yyerror
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
