#include <iostream>
#include <sstream>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "lexer.h"

void *ParseAlloc(void *(*mallocProc)(size_t));
void Parse(void *yyp,int yymajor,int yyminor);
void ParseFree( void *p, void (*freeProc)(void *));

extern std::istream *in;
extern std::string text;

void parse(input_t in) {
    void *parser = ParseAlloc(malloc);
    int tk = lex(in);
    while (tk != EOFI) {
        Parse(parser, tk, 0);
        tk = lex(in);
    }
    Parse(parser, 0, 0);
    ParseFree(parser, free);
}

int main()
{
    input_t in;

    parse(in);

    return 0;
}