#include <iostream>
#include <stdio.h>
#include <string>
#include <fstream>
#include <vector>
#include "lexer.h"

int main(int argc, char *argv[])
{
    if (argc == 1)
    {
        cerr << "Usage " << argv[0] << " <input file> Directive-List" << endl;
        return 1;
    }
    ifstream in(argv[1], ios::in);

    if (!in.is_open())
    {
        cerr << "Cannot open output file '" << argv[1] << "'" << endl;
        return 1;
    }
    /*string code;
    in >> code;
    std::istringstream ins;

    ins.str(code);*/
    ExprLexer lexer(in);
    while(lexer.getNextToken()!=Token::Eof){
        printf("%s\n", lexer.getLexeme().c_str());
    }
    return 0;
}