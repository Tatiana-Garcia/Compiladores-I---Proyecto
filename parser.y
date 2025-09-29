%code requires {
  #include "Node.h"
}

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <iostream>
#include <vector>
#include "Node.h"
using namespace std;

// Funciones Bison y demas
int yylex(void);
extern char* yytext;
void yyerror(const char *s);
Node* root;
int syntaxErrors = 0;
%}

%union {
    char* str;
    float f;
    int i;
    char c;
    Node* astTree;
}

/* tokens */
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


%type <astTree> program function function_list stmt_list statement expr print_arg else_clause param_list parameters type arg_list arguments
%%

program:
        function_list {root = new Node("PROGRAMA", ""); root->getChildren().push_back($1); $$ = root;}
    ;
    function_list: function { $$ = new Node("function_list", ""); $$->getChildren().push_back($1); }
                 | function_list function { $$ = $1; $$->getChildren().push_back($2); }
    ;

    function: FUNCTION IDENTIFIER LPARENTHESES param_list RPARENTHESES ARROW type LBRACE stmt_list RBRACE {

                $$ = new Node("function", $2);
                $$->getChildren().push_back($4);
                $$->getChildren().push_back($7);
                $$->getChildren().push_back($9);
            }
            | FUNCTION MAIN LPARENTHESES RPARENTHESES LBRACE stmt_list RBRACE {
                $$ = new Node("main", "main");
                $$->getChildren().push_back($6);
            }
            | FUNCTION IDENTIFIER LPARENTHESES param_list RPARENTHESES LBRACE stmt_list RBRACE{

                $$ = new Node("function", $2);
                $$->getChildren().push_back($4);
                $$->getChildren().push_back($7);
            }
            ;
    param_list: /*empty*/ { $$ = new Node("param_list", ""); }
              | parameters { $$ = $1; }
              ;
    parameters: IDENTIFIER COLON type {
                $$ = new Node("param", $1);
                $$->getChildren().push_back($3);
              }
              | parameters COMMA IDENTIFIER COLON type {
                $$ = $1;
                Node* param = new Node("param", $3);
                param->getChildren().push_back($5);
                $$->getChildren().push_back(param);
              }
              ;
    type: I32  { $$ = new Node("type", "i32"); }
        | F64  { $$ = new Node("type", "f64"); }
        | BOOL { $$ = new Node("type", "bool"); }
        | CHAR { $$ = new Node("type", "char"); }
        | STR  { $$ = new Node("type", "str"); }
        ;
    stmt_list: /*empty*/ { $$ = new Node("stmt_list", ""); }
             | statement { $$ = new Node("stmt_list", ""); $$->getChildren().push_back($1); }
             | stmt_list statement { $$ = $1; $$->getChildren().push_back($2); }
    statement: LET IDENTIFIER ASSIGN expr SEMICOLON {
                $$ = new Node("let", $2);
                $$->getChildren().push_back($4);
             }
             | IF expr LBRACE stmt_list RBRACE else_clause {
                $$ = new Node("if", "");
                $$->getChildren().push_back($2);
                $$->getChildren().push_back($4);
                if ($6) $$->getChildren().push_back($6);
             }
             | WHILE expr LBRACE stmt_list RBRACE {
                $$ = new Node("while", "");
                $$->getChildren().push_back($2);
                $$->getChildren().push_back($4);
             }
             | FOR IDENTIFIER ASSIGN expr SEMICOLON expr SEMICOLON expr LBRACE stmt_list RBRACE {
                $$ = new Node("for", $2);
                $$->getChildren().push_back($4);
                $$->getChildren().push_back($6);
                $$->getChildren().push_back($8);
                $$->getChildren().push_back($10);
             }
             | RETURN expr SEMICOLON {
                $$ = new Node("return", "");
                $$->getChildren().push_back($2);
             }
             | RETURN SEMICOLON {
                $$ = new Node("return", "void");
             }
             | PRINT LPARENTHESES print_arg RPARENTHESES SEMICOLON {
                $$ = new Node("print", "");
                $$->getChildren().push_back($3);
             }
             | PRINTLN LPARENTHESES print_arg RPARENTHESES SEMICOLON {
                $$ = new Node("println", "");
                $$->getChildren().push_back($3);
             }
             | expr SEMICOLON {
                $$ = new Node("exprStatement", "");
                $$->getChildren().push_back($1);
             }
             | error SEMICOLON {
                $$ = new Node("errorStatement", "Error de sintaxis en statement");
             }
             ;
    print_arg: STRING   { $$ = new Node("string", $1); }
             | expr { $$ = $1; }
             ;

    else_clause: /* empty */ { $$ = nullptr; }
               | ELSE LBRACE stmt_list RBRACE { $$ = new Node("else", ""); $$->getChildren().push_back($3); }
               ;
    expr: INTEGER { $$ = new Node("int", to_string($1)); }
        | FLOAT { $$ = new Node("float", to_string($1)); }
        | IDENTIFIER { $$ = new Node("id", $1); }
        | expr LESS expr {
            $$ = new Node("less", "<");
            $$->getChildren().push_back($1);
            $$->getChildren().push_back($3);
        }
        | expr GREATER expr {
            $$ = new Node("greater", ">");
            $$->getChildren().push_back($1);
            $$->getChildren().push_back($3);
        }
        | expr LESSOREQUAL expr {
            $$ = new Node("lessorequal", "<=");
            $$->getChildren().push_back($1);
            $$->getChildren().push_back($3);
        }
        | expr GREATEROREQUAL expr {
            $$ = new Node("greaterorequal", ">=");
            $$->getChildren().push_back($1);
            $$->getChildren().push_back($3);
        }
        | expr EQUAL expr {
            $$ = new Node("equal", "==");
            $$->getChildren().push_back($1);
            $$->getChildren().push_back($3);
        }
        | expr NOTEQUAL expr {
            $$ = new Node("notequal", "!=");
            $$->getChildren().push_back($1);
            $$->getChildren().push_back($3);
        }
        | expr PLUS expr {
            $$ = new Node("add", "+");
            $$->getChildren().push_back($1);
            $$->getChildren().push_back($3);
        }
        | expr MINUS expr {
            $$ = new Node("substract", "-");
            $$->getChildren().push_back($1);
            $$->getChildren().push_back($3);
        }
        | expr MUL expr {
            $$ = new Node("multiply", "*");
            $$->getChildren().push_back($1);
            $$->getChildren().push_back($3);
        }
        | expr DIV expr {
            $$ = new Node("divide", "/");
            $$->getChildren().push_back($1);
            $$->getChildren().push_back($3);
        }
        | expr OR expr {
            $$ = new Node("or", "||");
            $$->getChildren().push_back($1);
            $$->getChildren().push_back($3);
        }
        | expr AND expr {
            $$ = new Node("and", "&&");
            $$->getChildren().push_back($1);
            $$->getChildren().push_back($3);
        }
        | NOT expr {
            $$ = new Node("not", "!");
            $$->getChildren().push_back($2);
        }
        | IDENTIFIER LPARENTHESES arg_list RPARENTHESES {
            $$ = new Node("functionCall", $1);
            if ($3) $$->getChildren().push_back($3);
        }
        | LPARENTHESES expr RPARENTHESES { $$ = $2; }
        ;
    arg_list: /*empty*/ { $$ = nullptr; }
            | arguments { $$ = $1; }
            ;
    arguments: expr { $$ = new Node("arg", ""); $$->getChildren().push_back($1); }
             | arguments COMMA expr {
                $$ = $1;
                $$->getChildren().push_back($3);
             }
             ;

%%

// Definición de yyerror
void yyerror(const char *s) {
    fprintf(stderr, "\n\nError sintactico: %s en '%s'\n", s, yytext);
    if (root) {
        Node* errorNode = new Node("error", string(s) + " cerca de '" + string(yytext) + "'");
        root->getChildren().push_back(errorNode);
    }
    syntaxErrors++;
}
