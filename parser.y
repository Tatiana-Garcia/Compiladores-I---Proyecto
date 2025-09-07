%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Prototipos para que Bison conozca estas funciones:
int yylex(void);
void yyerror(const char *s);
%}

// Le decimos que el tipo de los valores es char*
%union {
    char* str;
    float f;
    int i;
    char c;
}

/* declare tokens */
%token <str> PRINT PRINTLN STRING IDENTIFIER
%token <f> FLOAT
%token <i> INTEGER
%token LET FUNCTION IF ELSE WHILE FOR RETURN MAIN
%token I32 F64 BOOL CHAR STR

%token AND OR NOT
%token PLUS MINUS MUL DIV ARROW
%token EQUAL NOTEQUAL LESSOREQUAL GREATEROREQUAL
%token LESS GREATER ASSIGN

%token LBRACE RBRACE LPARENTHESES RPARENTHESES
%token LBRACKET RBRACKET COMMA SEMICOLON COLON

%type <str> print_arg
%type <i> expr
%%

program:
        function_list
    ;
    function_list: function
                 | function_list function
    ;

    function: FUNCTION IDENTIFIER LPARENTHESES param_list RPARENTHESES ARROW type LBRACE stmt_list RBRACE
            | FUNCTION MAIN LPARENTHESES RPARENTHESES LBRACE stmt_list RBRACE
            | FUNCTION IDENTIFIER LPARENTHESES param_list RPARENTHESES LBRACE stmt_list RBRACE
            ;
    param_list: /*empty*/
              | parameters
              ;
    parameters: IDENTIFIER COLON type
              | parameters COMMA IDENTIFIER COLON type
              ;
    type: I32
        | F64
        | BOOL
        | CHAR
        | STR
        ;
    stmt_list: /*empty*/
             | statement
             | stmt_list statement
    statement: LET IDENTIFIER ASSIGN expr SEMICOLON
             | IF expr LBRACE stmt_list RBRACE else_clause
             | WHILE expr LBRACE stmt_list RBRACE
             | FOR IDENTIFIER ASSIGN expr SEMICOLON expr SEMICOLON expr LBRACE stmt_list RBRACE
             | RETURN expr SEMICOLON
             | RETURN SEMICOLON
             | PRINT LPARENTHESES print_arg RPARENTHESES SEMICOLON { printf("%s", $3); }
             | PRINTLN LPARENTHESES print_arg RPARENTHESES SEMICOLON { printf("%s\n", $3); }
             | expr SEMICOLON
             ;
    print_arg: STRING   { $$ = $1; }
             | expr {
                        static char buffer[256];
                        sprintf(buffer, "%d", $1);
                        $$ = strdup(buffer);
                   }
             ;

    else_clause: /* empty */
               | ELSE LBRACE stmt_list RBRACE
               ;
    expr: INTEGER
        | FLOAT
        | IDENTIFIER
        | expr LESS expr
        | expr GREATER expr
        | expr LESSOREQUAL expr
        | expr GREATEROREQUAL expr
        | expr EQUAL expr
        | expr NOTEQUAL expr
        | expr PLUS expr
        | expr MINUS expr
        | expr MUL expr
        | expr DIV expr
        | expr OR expr
        | expr AND expr
        | NOT expr
        | IDENTIFIER LPARENTHESES arg_list RPARENTHESES
        | LPARENTHESES expr RPARENTHESES
        ;
    arg_list: /*empty*/
            | arguments
            ;
    arguments: expr
             | arguments COMMA expr
             ;

%%

// Definición de yyerror
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
