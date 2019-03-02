#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <stdio.h>
#include <string.h>
#include "decaf_tokens.h"

static const size_t SIZE = 1024;
#define ERROR -1
#define EOFI 0

struct input_t {
    char *buf;
    char *lim;
    char *cur;
    char *tok;
    bool eof;
    std::istream& in;

    input_t(std::istream& in);

    bool fill(size_t need);
};

int lex(input_t & in);

int getLineno();
void reset();