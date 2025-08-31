%{
#include "parser.hpp"  // Para que conozca los tokens y YYSTYPE
%}

%%

"print"     { yylval.str = strdup(yytext); return PRINT; }
\"[^\"]*\"  { yylval.str = strdup(yytext); return STRING; }
[ \t\n]     ;   // ignorar espacios
.           { return yytext[0]; }

%%
int yywrap() { return 1; }
