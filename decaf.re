#include <fstream>
#include <iostream>
#include "lexer.h"
#include <sstream>

#   define YYCTYPE     char
#   define YYPEEK()    getChar()
#   define YYSKIP()    do { in.ignore(); if (in.eof()) return Token::Eof; } while(0)
#   define YYBACKUP()  mar = in.tellg()
#   define YYRESTORE() in.seekg(mar)

using namespace std;

Token ExprLexer::getNextToken()
{
    lexeme = "";
    flag = false;
    while(1){
    /*!re2c
        re2c:yyfill:enable = 0;

        lcom = "//";
        o_bcom = "/*";
        c_bcom = "*\/"; 
        eof = "\x00";
        eol = "\n";
        wsp = [' ']+;
        dec = [0-9]+;
        hex = "0x" [a-fA-F0-9]+;
        num = [dec|hex];
        iden =[_|a-zA-Z][_|a-zA-Z|0-9]*;
        str = "\"" [^"]* "\"";
    */

    if(state == 0){
        goto init;
    }else if(state == 1){
        goto line_comment;
    }else if(state == 2){
        goto block_comment;
    }

    line_comment:
        /*!re2c
            * { continue; }
            "\n" { state = 0; continue; }
            eof { return Token::Eof; }
        */

    block_comment:
        /*!re2c
            * { continue; }
            wsp { continue; }
            "\n" { continue; }
            c_bcom { state = 0; continue; }
            eof { return Token::Error; }
        */

    init:
    /*!re2c
        eol { lineno++; continue; }
        wsp { continue; }
        lcom { printf("%s\n", "line comment"); state = 1; continue;}
        o_bcom { printf("%s\n", "block comment"); state = 2; continue;}
        * {lexeme = "Error"; return Token::Error; }
        eof {lexeme = "EOF"; return Token::Eof; }
        "+" {lexeme = "+"; return Token::OpSum; }
        "-" {lexeme = "-"; return Token::OpRes; }
        "*" {lexeme = "*"; return Token::OpMul; }
        "/" {lexeme = "/"; return Token::OpDiv; }
        "<<" {lexeme = "<<"; return Token::OpMeM; }
        ">>" {lexeme = ">>"; return Token::OpMaM; }
        "%" {lexeme = "%"; return Token::OpMod; }
        "<" {lexeme = "<"; return Token::OpMen; }
        ">" {lexeme = ">"; return Token::OpMay; }
        "<=" {lexeme = "<="; return Token::OpMenI; }
        ">=" {lexeme = ">="; return Token::OpMayI; }
        "==" {lexeme = "=="; return Token::OpIgual; }
        "!=" {lexeme = "!="; return Token::OpDif; }
        "&&" {lexeme = "&&"; return Token::OpAnd; }
        "||" {lexeme = "||"; return Token::OpOr; }
        "!" {lexeme = "!"; return Token::OpNegar; }
        "=" {lexeme = "!"; return Token::Asignar; }
        dec {lexeme = "num"; return Token::Num; }
        hex {lexeme = "num"; return Token::Num; }
        ";" { lexeme = ";"; return Token::Semicolon; }
        "(" { lexeme = "("; return Token::OpenPar; }
        ")" { lexeme = ")"; return Token::ClosePar; }
        "{" { lexeme = "{"; return Token::OpenKey; }
        "}" { lexeme = "}"; return Token::CloseKey; }
        "[" { lexeme = "["; return Token::OpenBra; }
        "]" { lexeme = "]"; return Token::CloseBra; }
        "bool"{lexeme="bool";return Token::KBool;}
        "break"{lexeme="break";return Token::KBreak;}
        "continue"{lexeme="continue";return Token::KContinue;}
        "class"{lexeme="class";return Token::KClass;}
        "else"{lexeme="else";return Token::KElse;}
        "extends"{lexeme="extends";return Token::KExtends;}
        "false"{lexeme="false";return Token::KFalse;}
        "for"{lexeme="for";return Token::KFor;}
        "if"{lexeme="if";return Token::KIf;}
        "int"{lexeme="int";return Token::KInt;}
        "new"{lexeme="new";return Token::KNew;}
        "null"{lexeme="null";return Token::KNull;}
        "return"{lexeme="return";return Token::KReturn;}
        "rot"{lexeme="rot";return Token::KRot;}
        "true"{lexeme="true";return Token::KTrue;}
        "void"{lexeme="void";return Token::KVoid;}
        "while"{lexeme="while";return Token::KWhile;}
        iden { lexeme="iden"; return Token::Id; }
        str { lexeme="str"; return Token::StrLit; }
    */
    }
}

/*int main(int argc, char **argv)
{
    if (argc != 3) return 1;

    std::ifstream in2(argv[1], std::ios::binary);
    if (in2.fail()) return 2;

    setIfstream(in2);

    while(getToken()!=Token::Eof){
        printf("%s\n", lexeme.c_str());
    }

    return 0;
}*/