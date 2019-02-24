%include {
    #include <assert.h>
    #include <iostream>

    extern int lineno;
}

%token_type {int}

%syntax_error {
    std::cout << "Syntax error at line " << lineno << std::endl;
    exit(1);
}

%parse_failure {
    fprintf(stderr,"Giving up.  Parser is hopelessly lost...\n");
}

program ::= KWCLASS ID OPENCUR field_decl methods_field CLOSECUR. { std::cout << "PARSER COMPLETED!!!" << std::endl; }
field_decl ::= field_decl decl SEMICOLON. {}
field_decl ::= decl SEMICOLON. {} 
field_decl ::= .
decl ::= type list_decl. {}
list_decl ::= list_decl COMMA ID OPENBRA NUMBER CLOSEBRA. {}
list_decl ::= list_decl COMMA ID init. {}
list_decl ::= ID OPENBRA NUMBER CLOSEBRA. {}
list_decl ::= ID init. {}
type ::= KWINT. {}
type ::= KWBOOL. {}
init ::= OPASSIGN constant. {}
init ::= .
constant ::= NUMBER. {}
constant ::= KWTRUE. {}
constant ::= KWFALSE. {}

methods_field ::= methods_field sub_program. {}
methods_field ::= sub_program. {}
methods_field ::= .
sub_program ::= method_type ID OPENPAR params CLOSEPAR block. {}
method_type ::= type. {}
method_type ::= KWVOID. {}

params ::= params COMMA type ID. {}
params ::= type ID. {}
params ::= . {}

block ::= OPENCUR field_decl statements CLOSECUR. {}

statements ::= statements statement. {}
statements ::= statement.
statements ::= .

statement ::= assign SEMICOLON. {}
statement ::= method_call SEMICOLON. {}
statement ::= if_st. {}
statement ::= while. {}
statement ::= KWRETURN expr SEMICOLON. {}
statement ::= KWRETURN SEMICOLON. {}
statement ::= KWBREAK SEMICOLON. {}
statement ::= KWCONTINUE SEMICOLON. {}
statement ::= for_st. {}
statement ::= block. {}

assign ::= lvalue OPASSIGN expr. {}

method_call ::= ID OPENPAR exprs_list CLOSEPAR. {}
method_call ::= SOP OPENPAR arguments CLOSEPAR. {}
method_call ::= SOPLN OPENPAR arguments CLOSEPAR. {}
method_call ::= SOR OPENPAR CLOSEPAR. {}
method_call ::= RANDOM OPENPAR expr CLOSEPAR. {}

if_st ::= KWIF OPENPAR expr CLOSEPAR block opt_else. {}
opt_else ::= KWELSE block. {}
opt_else ::= . {}

while ::= KWWHILE OPENPAR expr CLOSEPAR block. {}

for_st ::= KWFOR OPENPAR list_assignings SEMICOLON expr SEMICOLON list_assignings CLOSEPAR block. {}

list_assignings ::= list_assignings COMMA assign. {}
list_assignings ::= assign. {}

exprs_list ::= exprs_list COMMA expr. {}
exprs_list ::= expr. {}
exprs_list ::= .

arguments ::= arguments COMMA argument. {}
arguments ::= argument. {}

argument ::= expr. {}
argument ::= STRLIT. {}

lvalue ::= ID. {}
lvalue ::= ID OPENBRA expr CLOSEBRA. {}

%left AND.
%left OR.
%nonassoc EQ NE GT GE LT LE.
%left SHL SHR.
%left MOD.
%left ADD SUB.
%left MUL DIV.
%right NOT NEG.

expr ::= expr AND expr. {}
expr ::= expr OR expr. {}
expr ::= expr EQ expr. {}
expr ::= expr NE expr. {}
expr ::= expr GT expr. {}
expr ::= expr GE expr. {}
expr ::= expr LT expr. {}
expr ::= expr LE expr. {}
expr ::= expr SHL expr. {}
expr ::= expr SHR expr. {}
expr ::= expr MOD expr. {}
expr ::= expr ADD expr. {}
expr ::= expr SUB expr. {}
expr ::= expr MUL expr. {}
expr ::= expr DIV expr. {}
expr ::= NOT expr. {}
expr ::= NEG expr. {}
expr ::= constant. {}
expr ::= ID. {}
expr ::= CHAR_CONST.{}
expr ::= method_call. {}
expr ::= OPENPAR expr CLOSEPAR. {}