#include "../lexer.h"

/*!max:re2c*/

std::string text;
int state = 0;
int lineno = 1;

int getLineno(){
    return lineno;
}

void reset(){
    lineno = 1;
}

input_t::input_t(std::istream& in) : in(in){
    buf = new char[SIZE+YYMAXFILL];
    lim = buf + SIZE;
    cur = lim;
    tok = lim;
    eof = false;
}

bool input_t::fill(size_t need){
    if (eof) {
            return false;
    }
    const size_t free = tok - buf;
    if (free < need) {
        return false;
    }
    memmove(buf, tok, lim - tok);
    lim -= free;
    cur -= free;
    tok -= free;
    in.read(buf,free);
    lim += in.gcount();
    
    if (lim < buf + SIZE) {
        eof = true;
        memset(lim, 0, YYMAXFILL);
        lim += YYMAXFILL;
    }
    return true;
}

int lex(input_t & in)
{
    char *YYMARKER;
    while(1){
        text="";
        in.tok = in.cur;
        if(in.cur == 0 && in.eof){
            return EOFI;
        }
        /*!re2c
            re2c:define:YYCTYPE = char;
            re2c:define:YYCURSOR = in.cur;
            re2c:define:YYLIMIT = in.lim;
            re2c:define:YYFILL = "if (!in.fill(@@)) return false;";
            re2c:define:YYFILL:naked = 1;

            line = "//";
            strbeg = "\"";
            oblock = "/*";
            cblock = "*\/";
            end = "\x00";
            wsp = [" "]+;
            eol = [\n];
            dec = [0-9]*;
            hex = '0x' [0-9a-fA-F]+;
            id =[_|a-zA-Z][_|a-zA-Z|0-9]*;
            dstr = "\"" [^"]* "\"";
            char_const = "'" [^'] "'";*/

        if(state == 0){
            goto init;
        }else if(state == 1){
            goto line_comment;
        }else if(state == 2){
            goto block_comment;
        }else if(state == 3){
            goto str_literal;
        }

        line_comment:
        /*!re2c
            * { continue; }
            "\n" { lineno++; state = 0; continue; }
            end { text = "eof"; return EOFI; }
        */

        block_comment:
        /*!re2c
            * { continue; }
            "\n" { lineno++; continue; }
            cblock { state = 0; continue; }
            end { text = "error"; return ERROR; }
        */

        str_literal:
        /*!re2c
            * { continue; }
            "\n" { lineno++; continue; }
            cblock { state = 0; continue; }
            end { text = "error"; return ERROR; }
        */

        init:
        /*!re2c
            *   { text = "error"; return ERROR; }
            end { text = "eof"; return EOFI; }
            wsp { continue; }
            eol { lineno++; continue; }
            line { state = 1; continue; }
            oblock { state = 2; continue; }
            dec { std::string t(in.tok,in.cur-in.tok);
                text=t;
                return NUMBER; }
            hex { std::string t(in.tok,in.cur-in.tok);
                text=std::to_string(std::stoul(t, nullptr, 16));
                return NUMBER; }
            char_const { std::string t(in.tok,in.cur-in.tok);
                text=std::to_string((int)t.at(1));
                return NUMBER; }
            dstr { std::string t(in.tok,in.cur-in.tok);
                text=t; return STRLIT; }
            "class" { text = "class"; return KWCLASS; }
            "int" { text = "int"; return KWINT; }
            "bool" { text = "bool"; return KWBOOL; }
            "true" { text = "true"; return KWTRUE; }
            "false" { text = "false"; return KWFALSE; }
            "void" { text = "void"; return KWVOID; }
            "if" { text = "if"; return KWIF; }
            "else" { text = "if"; return KWELSE; }
            "while" { text = "while"; return KWWHILE; }
            "for" { text = "for"; return KWFOR; }
            "return" { text = "return"; return KWRETURN; }
            "break" { text = "break"; return KWBREAK; }
            "continue" { text = "class"; return KWCONTINUE; }
            "System.out.print" { text = "System.out.print"; return SOP; }
            "System.out.println" { text = "System.out.println"; return SOPLN; }
            "System.in.read" { text = "System.in.read"; return SOR; }
            "Random.nextInt" { text = "Random.nextInt"; return RANDOM; }
            id { std::string t(in.tok,in.cur-in.tok);
                text=t;
                return ID; }
            "{" { text = "{"; return OPENCUR; }
            "}" { text = "}"; return CLOSECUR; }
            "[" { text = "["; return OPENBRA; }
            "]" { text = "]"; return CLOSEBRA; }
            "(" { text = "("; return OPENPAR; }
            ")" { text = ")"; return CLOSEPAR; }
            ";" { text = ";"; return SEMICOLON; }
            "," { text = ","; return COMMA; }
            "=" { text = "="; return OPASSIGN; }
            "+" { text = "+"; return ADD; }
            "-" { text = "-"; return SUB; }
            "*" { text = "*"; return MUL; }
            "/" { text = "/"; return DIV; }
            "%" { text = "%"; return MOD; }
            "!" { text = "!"; return NEG; }
            "<" { text = "<"; return LT; }
            ">" { text = ">"; return GT; }
            "<=" { text = "<="; return LE; }
            ">=" { text = ">="; return GE; }
            "<<" { text = "<<"; return SHL; }
            ">>" { text = ">>"; return SHR; }
            "==" { text = "=="; return EQ; }
            "!=" { text = "!="; return NE; }
        */
    }
}
