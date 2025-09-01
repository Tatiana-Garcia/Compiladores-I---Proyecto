%{
#include "parser.hpp"  // Para que conozca los tokens y YYSTYPE
//[0-9]+"."[0-9]+
%}

%%
"print!"    { yylval.str = strdup(yytext); return PRINT; }
"let"       { yylval.str = strdup(yytext); return LET; }
"fn"        { yylval.str = strdup(yytext); return FUNCTION; }
"if"        { yylval.str = strdup(yytext); return IF; }
"else"      { yylval.str = strdup(yytext); return ELSE; }
"while"     { yylval.str = strdup(yytext); return WHILE; }
"for"       { yylval.str = strdup(yytext); return FOR; }
"return"    { yylval.str = strdup(yytext); return RETURN; }
"main"      { yylval.str = strdup(yytext); return MAIN; }

"i32"        { yylval.str = strdup(yytext); return I32; }
"f64"        { yylval.str = strdup(yytext); return F64; }
"bool"       { yylval.str = strdup(yytext); return BOOL; }
"char"       { yylval.str = strdup(yytext); return CHAR; }
"str"        { yylval.str = strdup(yytext); return STR; }

[a-zA-Z_][a-zA-Z0-9_]*   { yylval.str = strdup(yytext); return IDENTIFIER; }
[0-9]+\.[0-9]+           { yylval.str = strdup(yytext); return FLOAT; }
[0-9]+                   { yylval.str = strdup(yytext); return INTEGER; }

"&&"        { yylval.str = strdup(yytext); return AND; }
"||"        { yylval.str = strdup(yytext); return OR; }
"!"         { yylval.str = strdup(yytext); return NOT; }
"+"         { yylval.str = strdup(yytext); return PLUS; }
"-"         { yylval.str = strdup(yytext); return MINUS; }
"*"         { yylval.str = strdup(yytext); return MUL; }
"/"         { yylval.str = strdup(yytext); return DIV; }
"->"        { yylval.str = strdup(yytext); return ARROW; }
"=="        { yylval.str = strdup(yytext); return EQUAL; }
"!="        { yylval.str = strdup(yytext); return NOTEQUAL; }
"<="        { yylval.str = strdup(yytext); return LESSOREQUALTHAN; }
">="        { yylval.str = strdup(yytext); return GREATEROREQUALTHAN; }
"<"         { yylval.str = strdup(yytext); return LESSTHAN; }
">"         { yylval.str = strdup(yytext); return GREATERTHAN; }
"="         { yylval.str = strdup(yytext); return ASSIGN; }

"{"         { yylval.str = strdup(yytext); return LBRACE; }
"}"         { yylval.str = strdup(yytext); return RBRACE; }
"("         { yylval.str = strdup(yytext); return LPARENTHESES; }
")"         { yylval.str = strdup(yytext); return RPARENTHESES; }
"["         { yylval.str = strdup(yytext); return LBRACKET; }
"]"         { yylval.str = strdup(yytext); return RBRACKET; }
","         { yylval.str = strdup(yytext); return COMMA; }
";"         { yylval.str = strdup(yytext); return SEMICOLON; }
":"         { yylval.str = strdup(yytext); return COLON; }

\"[^\"]*\"  { yylval.str = strdup(yytext); return STRING; }
[ \t\n]+    ;   // ignorar espacios

"//".*                        ;
"/*"([^*]|\*+[^*/])*\*+"/"    ;
.           { return yytext[0]; }

%%
int yywrap() { return 1; }
