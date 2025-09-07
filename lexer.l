%{
#include "parser.hpp"  // Para que conozca los tokens y YYSTYPE
//[0-9]+"."[0-9]+
%}

%%
"println!"  { return PRINTLN; }
"print!"    { return PRINT; }
"let"       { return LET; }
"fn"        { return FUNCTION; }
"if"        { return IF; }
"else"      { return ELSE; }
"while"     { return WHILE; }
"for"       { return FOR; }
"return"    { return RETURN; }
"main"      { return MAIN; }

"i32"        { return I32; }
"f64"        { return F64; }
"bool"       { return BOOL; }
"char"       { return CHAR; }
"str"        { return STR; }

[a-zA-Z_][a-zA-Z0-9_]*   { yylval.str = strdup(yytext); return IDENTIFIER; }
[0-9]+\.[0-9]+           { yylval.f = atof(yytext); return FLOAT; }
[0-9]+                   { yylval.i = atoi(yytext); return INTEGER; }
\"[^\"]*\"               { yylval.str = strdup(yytext); return STRING; }

"&&"        { return AND; }
"||"        { return OR; }
"!"         { return NOT; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return MUL; }
"/"         { return DIV; }
"->"        { return ARROW; }
"=="        { return EQUAL; }
"!="        { return NOTEQUAL; }
"<="        { return LESSOREQUAL; }
">="        { return GREATEROREQUAL; }
"<"         { return LESS; }
">"         { return GREATER; }
"="         { return ASSIGN; }

"{"         { return LBRACE; }
"}"         { return RBRACE; }
"("         { return LPARENTHESES; }
")"         { return RPARENTHESES; }
"["         { return LBRACKET; }
"]"         { return RBRACKET; }
","         { return COMMA; }
";"         { return SEMICOLON; }
":"         { return COLON; }

[ \t\n]+    ;   // ignorar espacios

"//".*                        ;
"/\*([^*]|\*+[^/*])*\*+/"    ;
.           { return yytext[0]; }

%%
int yywrap() { return 1; }
