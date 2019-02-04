#define DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN

#include <sstream>
#include <memory>
#include <cstring>
#include "doctest.h"
#include "lexer.h"

const char *test1 = "45 + 10";
const char *test2 = "_var_1 + _var_2";
const char *test5 = "//Line comment\n"
                    "45 // Line Comment\n"
                    "+ // Line Comment\n"
                    "10 // Line Comment\n"
                    "//";

const char *test6 = "/* Block comment */\n"
                    "/* Block comment */ 45 /* Block comment */ + /* Block comment */ 10\n";

const char *test7 = "/* Block comment *** \n"
                    " Block comment !!! /// */45/* Block comment /// \n"
                    " Block comment !!! /// */ + 10/* Block comment /// \n"
                    " Block comment !!! /// */";

const char *test8 = "//Operadores\n+ - / * ^ < > <= >= = <> <- y o";

const char *test9 = "123242332 \"HOLA COMO ESTAS??\" \'a\' xyz verdadero falso fin repita mientras para";

TEST_CASE("Add expr with numbers")
{
    std::istringstream in;

    in.str(test1);
    ExprLexer l(in);
    Token tk = l.getNextToken();

    CHECK(tk == Token::Num);
    tk = l.getNextToken();
    CHECK(tk == Token::OpSum);
    tk = l.getNextToken();
    CHECK(tk == Token::Num);
    tk = l.getNextToken();
    CHECK(tk == Token::Eof);
}

TEST_CASE("Add expr with variables")
{
    std::istringstream in;

    in.str(test2);
    ExprLexer l(in);
    Token tk = l.getNextToken();

    CHECK(tk == Token::Id);
    tk = l.getNextToken();
    CHECK(tk == Token::OpSum);
    tk = l.getNextToken();
    CHECK(tk == Token::Id);
    tk = l.getNextToken();
    CHECK(tk == Token::Eof);
}

TEST_CASE("Big buffer")
{
    std::istringstream in;
    const int sizeKb = 64;
    int lastPos = sizeKb * 1024 - 1;
    std::unique_ptr<char[]> buff(new char[sizeKb * 1024]);
    char *p = buff.get();

    memset(p, ' ', sizeKb * 1024);
    int pos = lastPos - strlen(test1);
    strcpy(&p[pos], test1);
    p[lastPos] = '\0';

    in.str(p);
    ExprLexer l(in);
    Token tk = l.getNextToken();

    CHECK(tk == Token::Num);
    tk = l.getNextToken();
    CHECK(tk == Token::OpSum);
    tk = l.getNextToken();
    CHECK(tk == Token::Num);
    tk = l.getNextToken();
    CHECK(tk == Token::Eof);
}

TEST_CASE("Line comments")
{
    std::istringstream in;

    in.str(test5);
    ExprLexer l(in);
    Token tk = l.getNextToken();

    CHECK(tk == Token::Num);
    CHECK(l.getLexeme() == "45");
    tk = l.getNextToken();
    CHECK(tk == Token::OpSum);
    CHECK(l.getLexeme() == "+");
    tk = l.getNextToken();
    CHECK(tk == Token::Num);
    CHECK(l.getLexeme() == "10");
    tk = l.getNextToken();
    CHECK(tk == Token::Eof);
}

TEST_CASE("Block comments 1")
{
    std::istringstream in;

    in.str(test6);
    ExprLexer l(in);
    Token tk = l.getNextToken();

    CHECK(tk == Token::Num);
    CHECK(l.getLexeme() == "45");
    tk = l.getNextToken();
    CHECK(tk == Token::OpSum);
    CHECK(l.getLexeme() == "+");
    tk = l.getNextToken();
    CHECK(tk == Token::Num);
    CHECK(l.getLexeme() == "10");
    tk = l.getNextToken();
    CHECK(tk == Token::Eof);
}

TEST_CASE("Block comments 2")
{
    std::istringstream in;

    in.str(test7);
    ExprLexer l(in);
    Token tk = l.getNextToken();

    CHECK(tk == Token::Num);
    CHECK(l.getLexeme() == "45");
    tk = l.getNextToken();
    CHECK(tk == Token::OpSum);
    CHECK(l.getLexeme() == "+");
    tk = l.getNextToken();
    CHECK(tk == Token::Num);
    CHECK(l.getLexeme() == "10");
    tk = l.getNextToken();
    CHECK(tk == Token::Eof);
}

TEST_CASE("Operadores")
{
    //Operadores\n + - / * ^ < > <= >= =
    std::istringstream in;

    in.str(test8);
    ExprLexer l(in);
    Token tk = l.getNextToken();
    CHECK(tk == Token::OpSum);
    CHECK(l.getLexeme() == "+");
    tk = l.getNextToken();
    CHECK(tk == Token::OpRes);
    CHECK(l.getLexeme() == "-");
    tk = l.getNextToken();
    CHECK(tk == Token::OpDiv);
    CHECK(l.getLexeme() == "/");
    tk = l.getNextToken();
    CHECK(tk == Token::OpMul);
    CHECK(l.getLexeme() == "*");

    tk = l.getNextToken();
    CHECK(tk == Token::OpMen);
    CHECK(l.getLexeme() == "<");
    tk = l.getNextToken();
    CHECK(tk == Token::OpMay);
    CHECK(l.getLexeme() == ">");
    tk = l.getNextToken();
    CHECK(tk == Token::OpMenI);
    CHECK(l.getLexeme() == "<=");
    tk = l.getNextToken();
    CHECK(tk == Token::OpMayI);
    CHECK(l.getLexeme() == ">=");
    tk = l.getNextToken();
    CHECK(tk == Token::OpIgual);
    CHECK(l.getLexeme() == "==");
    tk = l.getNextToken();
    CHECK(tk == Token::OpDif);
    CHECK(l.getLexeme() == "!=");
    tk = l.getNextToken();
    CHECK(tk == Token::Asignar);
    CHECK(l.getLexeme() == "=");

    tk = l.getNextToken();
    CHECK(tk == Token::OpAnd);
    CHECK(l.getLexeme() == "&&");
    tk = l.getNextToken();
    CHECK(tk == Token::OpOr);
    CHECK(l.getLexeme() == "||");
    tk = l.getNextToken();

    CHECK(tk == Token::Eof);
}

TEST_CASE("Factors")
{
    //123242332 \"HOLA COMO ESTAS??\" \'a\' xyz Verdadero FALSO
    std::istringstream in;

    in.str(test9);
    ExprLexer l(in);
    Token tk = l.getNextToken();
    CHECK(tk == Token::Num);
    CHECK(l.getLexeme() == "123242332");
    tk = l.getNextToken();
    CHECK(tk == Token::StrLit);
    CHECK(l.getLexeme() == "\"HOLA COMO ESTAS??\"");
    //tk = l.getNextToken();
    //CHECK(tk == Token::Caracter);
    //CHECK(l.getLexeme() == "\'a\'");
    tk = l.getNextToken();
    CHECK(tk == Token::Id);
    CHECK(l.getLexeme() == "xyz");
    tk = l.getNextToken();
    CHECK(tk == Token::KTrue);
    CHECK(l.getLexeme() == "true");
    tk = l.getNextToken();
    CHECK(tk == Token::KFalse);
    CHECK(l.getLexeme() == "false");
    //123242332 \"HOLA COMO ESTAS??\" \'a\' xyz verdadero falso fin repita mientras para
    
    tk = l.getNextToken();
    CHECK(tk == Token::KClass);
    CHECK(l.getLexeme() == "class");

    tk = l.getNextToken();
    CHECK(tk == Token::KElse);
    CHECK(l.getLexeme() == "else");
    tk = l.getNextToken();
    CHECK(tk == Token::KFor);
    CHECK(l.getLexeme() == "for");
}