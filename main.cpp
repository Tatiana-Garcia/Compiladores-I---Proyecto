#include <iostream>
//#include <FlexLexer.h>
#include <fstream>
extern int yyparse();

using namespace std;

int main() {
    std::cout << "Ingresa codigo para analizar:\n";
    yyparse();
    return 0;
}