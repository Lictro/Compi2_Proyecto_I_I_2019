#ifndef _EXPR_LEXER_H
#define _EXPR_LEXER_H
#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include "tokens.h"

using namespace std;

class ExprLexer {
public:
    ExprLexer(std::ifstream &in): in(in) {lexeme="";}
    ~ExprLexer(){}

    Token getNextToken();
    int getLineNo() { return lineno; }
    std::string getText() { return text; }
    char getChar(){
        char ch = in.peek();
        if(ch != -1)
            lexeme.push_back(ch);
        //cout<<(int)ch<<endl;
        return ch;
    }
    string getLexeme(){
        return lexeme;
    }

private:
    int lineno;
    ifstream &in;
    string text;
    streampos mar;
    string lexeme;
    bool flag;
    int state;

};
#endif
