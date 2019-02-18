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

block ::= OPENCUR statements CLOSECUR. {}

statements ::= statements statement. {}
statements ::= statement.
statements ::= .

statement ::= assign SEMICOLON. {}
statement ::= method_call SEMICOLON. {}
statement ::= if_st. {}
statement ::= while. {}
statement ::= KWRETURN condition SEMICOLON. {}
statement ::= KWRETURN SEMICOLON. {}
statement ::= KWBREAK SEMICOLON. {}
statement ::= KWCONTINUE SEMICOLON. {}
statement ::= for_st. {}

assign ::= lvalue OPASSIGN condition. {}

method_call ::= ID OPENPAR exprs_list CLOSEPAR. {}
method_call ::= SOP OPENPAR arguments CLOSEPAR. {}
method_call ::= SOPLN OPENPAR arguments CLOSEPAR. {}
method_call ::= SOR OPENPAR CLOSEPAR. {}
method_call ::= RANDOM OPENPAR condition CLOSEPAR. {}

if_st ::= KWIF OPENPAR condition CLOSEPAR block opt_else. {}
opt_else ::= KWELSE block. {}
opt_else ::= . {}

while ::= KWWHILE OPENPAR condition CLOSEPAR block. {}

for_st ::= KWFOR OPENPAR list_asignings SEMICOLON condition SEMICOLON list_asignings CLOSEPAR block. {}

list_asignings ::= list_asignings COMMA assign. {}
list_asignings ::= assign. {}

exprs_list ::= exprs_list COMMA condition. {}
exprs_list ::= condition. {}
exprs_list ::= .

arguments ::= arguments COMMA argument. {}
arguments ::= argument. {}

argument ::= condition. {}
argument ::= STRLIT. {}

lvalue ::= ID. {}
lvalue ::= ID OPENBRA condition CLOSEBRA. {}

condition ::= logic_expr. {}
condition ::= logic_expr AND logic_expr. {}
condition ::= logic_expr OR logic_expr. {}

logic_expr ::= aritexpr MAYOR aritexpr. {}
logic_expr ::= aritexpr MENOR aritexpr. {}
logic_expr ::= aritexpr MAYORIGUAL aritexpr. {}
logic_expr ::= aritexpr MENORIGUAL aritexpr. {}
logic_expr ::= aritexpr IGUAL aritexpr. {}
logic_expr ::= aritexpr DISTINTO aritexpr. {}
logic_expr ::= aritexpr. {}

aritexpr ::= aritexpr SUMA term. {}
aritexpr ::= aritexpr RESTA term. {}
aritexpr ::= term. {}

term ::= term MUL factor. {}
term ::= term DIV factor. {}
term ::= term MOD factor. {}
term ::= factor. {}

unary ::= RESTA. {}
unary ::= NEGAR. {}
unary ::= . {}

factor ::= unary constant. {}
factor ::= unary lvalue. {}
factor ::= unary method_call. {}
factor ::= unary OPENPAR condition CLOSEPAR. {}