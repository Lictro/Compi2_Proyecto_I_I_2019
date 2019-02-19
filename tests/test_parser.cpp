#define DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN

#include <sstream>
#include <memory>
#include <cstring>
#include <exception>
#include "doctest.h"
#include "../lexer.h"

std::istringstream in;

void *ParseAlloc(void *(*mallocProc)(size_t));
void Parse(void *yyp,int yymajor,int yyminor);
void ParseFree( void *p, void (*freeProc)(void *));

int tk;
void parse(input_t in) {
    void *parser = ParseAlloc(malloc);
    tk = lex(in);
    while (tk != EOFI) {
        Parse(parser, tk, 0);
        tk = lex(in);
    }
    Parse(parser, 0, 0);
    ParseFree(parser, free);
}

const char *test1 = "class GreatestCommonDivisor {\n"
                    "   int a = 10;\n"
                    "   int b = 20;\n"
                    "   void main() {\n"
                    "       int x;\n"
                    "       x = a;\n"
                    "       y = b;\n"
                    "       z = gcd(x, y);\n"
                    "   }\n"
                    "   // Funcion que calcula el maximo comun divisor\n"
                    "   int gcd(int a, int b) {\n"
                    "       if (b == 0) { return (a); }\n"
                    "       else { return ( gcd(b, a % b) ); }\n"
                    "   }\n"
                    "}";

TEST_CASE("GreatestCommonDivisor") {
    in.str(test1);
    input_t inp(in);

    parse(inp);

    CHECK( getLineno() == 15);
    CHECK( tk == EOFI);
}

const char *test2 = "class ArithmeticOperations {\n"
                    "   void main() {\n"
                    "       int a, b, result;\n"
                    "       a = 10;\n"
                    "       b = 5;\n"
                    "       result = suma(a, b);\n"
                    "       System.out.println(result);\n"
                    "       result = resta(a, b);\n"
                    "       System.out.println(result);\n"
                    "       result = mult(a, b);\n"
                    "       System.out.println(result);\n"
                    "       result = divi(a, b);\n"
                    "       System.out.println(result);\n"
                    "   }\n"
                    "   // Funciones que calculan operaciones aritmeticas\n"
                    "   int suma(int a, int b) {\n"
                    "       return a+b;\n"
                    "   }\n"
                    "   int resta(int a, int b) {\n"
                    "       return a-b;\n"
                    "   }\n"
                    "   int mult(int a, int b) {\n"
                    "       return a*b;\n"
                    "   }\n"
                    "   int divi(int a, int b) {\n"
                    "       return a/b;\n"
                    "   }\n"
                    "}";

TEST_CASE("ArithmeticOperations") {
    in.clear();
    in.str(test2);
    reset();
    input_t inp(in);

    parse(inp);

    CHECK( getLineno() == 28);
    CHECK( tk == EOFI);
}

const char *test3 = "class IfStatement {\n"
                    "   int a = 10;\n"
                    "   int b = 20;\n"
                    "   int c = 30;\n"
                    "   int d = 40;\n"
                    "   bool flag = true;\n"
                    "   void main() {\n"
                    "       if (flag == true) {\n"
                    "           System.out.println(a);\n"
                    "           System.out.println(b);\n"
                    "       } else {\n"
                    "           System.out.println(c);\n"
                    "           System.out.println(d);\n"
                    "       }\n"
                    "   }\n"
                    "}";

TEST_CASE("IfStatement") {
    in.clear();
    in.str(test3);
    reset();
    input_t inp(in);

    parse(inp);

    CHECK( getLineno() == 16);
    CHECK( tk == EOFI);
}

const char *test4 = "class WhileStatement {\n"
                    "   int a = 1;\n"
                    "   int b = 10;\n"
                    "   void main() {\n"
                    "       while (a <= b) {\n"
                    "           System.out.println(a);\n"
                    "           a = a + 1;\n"
                    "       }\n"
                    "   }\n"
                    "}";

TEST_CASE("WhileStatement") {
    in.clear();
    in.str(test4);
    reset();
    input_t inp(in);

    parse(inp);

    CHECK( getLineno() == 10);
    CHECK( tk == EOFI);
}

const char *test5 = "class MethodCall {\n"
                    "   int a = 1;\n"
                    "   int b = 10;\n"
                    "   void main() {\n"
                    "       System.out.println(a);\n"
                    "       System.out.print(b);\n"
                    "       a = System.in.read();\n"
                    "       b = Random.nextInt(a);\n"
                    "       System.out.println(a);\n"
                    "       System.out.print(b);\n"
                    "   }\n"
                    "}";

TEST_CASE("MethodCall") {
    in.clear();
    in.str(test5);
    reset();
    input_t inp(in);

    parse(inp);

    CHECK( getLineno() == 12);
    CHECK( tk == EOFI);
}

const char *test6 = "class test {\n"
                    "   int a = 1;\n"
                    "   int b = 10;\n"
                    "   void main() {\n"
                    "       while(true){\n"
                    "           a = a + 1;\n"
                    "           if(a>23){\n"
                    "               break;\n"
                    "           }else{\n"
                    "               continue;\n"
                    "           }\n"
                    "           System.out.print(\"Dont must print this!!!\n\");"
                    "       }\n"
                    "return;"
                    "   }\n"
                    "}";

TEST_CASE("ContinueBreakReturn") {
    in.clear();
    in.str(test6);
    reset();
    input_t inp(in);

    parse(inp);

    CHECK( getLineno() == 14);
    CHECK( tk == EOFI);
}