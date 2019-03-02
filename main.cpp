#include <iostream>
#include <sstream>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "lexer.h"
#include "decaf_ast.h"

void *ParseAlloc(void *(*mallocProc)(size_t));
void Parse(void *yyp,int yymajor,ASTNode*);
void ParseFree( void *p, void (*freeProc)(void *));

extern std::string text;

void parse(input_t in) {
    void *parser = ParseAlloc(malloc);
    int tk = lex(in);
    while (tk != EOFI) {
        if(tk == ID){
            Parse(parser, tk, new LValueSim(text));
        }else if(tk == NUMBER){
            Parse(parser, tk, new Number(std::stoi(text)));
        }else{
            Parse(parser, tk, nullptr);
        }
        tk = lex(in);
    }
    Parse(parser, 0, 0);
    ParseFree(parser, free);
}

int main(int argc, char** argv)
{
    std::ifstream t(argv[1]);
    std::istringstream in;
    std::string str((std::istreambuf_iterator<char>(t)),
                 std::istreambuf_iterator<char>());
    in.str(str.c_str());
    input_t inp(in);

    parse(inp);

    return 0;
}