%include {
    #include <assert.h>
    #include <iostream>
    #include "decaf_ast.h"

    extern int lineno;
}

%token_type {ASTNode*}

%syntax_error {
    std::cout << "Syntax error at line " << lineno << std::endl;
    exit(1);
}

%parse_failure {
    fprintf(stderr,"Giving up.  Parser is hopelessly lost...\n");
}

program ::= KWCLASS ID OPENCUR field_decl(B) methods_field(C) CLOSECUR. { std::cout << "PARSER COMPLETED!!!\n"<< B->toString() << "\n" << C->toString() << std::endl; }
field_decl(A) ::= field_decl(B) decl(C) SEMICOLON. {A=B; dynamic_cast<DeclareField*>(A)->decla_list.push_back(C);}
field_decl(A) ::= decl(B) SEMICOLON. {A = new DeclareField; dynamic_cast<DeclareField*>(A)->decla_list.push_back(B);} 
field_decl(A) ::= . { A = nullptr; }
decl(A) ::= type(B) list_decl(C). {A = new Declaration(B,C);}

list_decl(A) ::= list_decl(B) COMMA symbol(C). {A=B; dynamic_cast<DeclareList*>(A)->symbols.push_back(C);}
list_decl(A) ::= symbol(B). {A = new DeclareList; dynamic_cast<DeclareList*>(A)->symbols.push_back(B);}

symbol(A) ::= ID(B) OPENBRA NUMBER(C) CLOSEBRA. {A = new DeclareIdx(B->toString(), dynamic_cast<Number*>(C)->number);}
symbol(A) ::= ID(B) init(C). {A = new DeclareSimple(B->toString(), C);}

type(A) ::= KWINT. {A = new IntegerType();}
type(A) ::= KWBOOL. {A = new BoolType();}
init(A) ::= OPASSIGN constant(B). {A = B;}
init(A) ::= . {A = nullptr; }
constant(A) ::= NUMBER(B). {A = B;}
constant(A) ::= KWTRUE. {A = new BoolConst(1);}
constant(A) ::= KWFALSE. {A = new BoolConst(0);}

methods_field(A) ::= methods_field(B) sub_program(C). {A = B; dynamic_cast<MethodsField*>(A)->methods.push_back(C);}
methods_field(A) ::= sub_program(B). {A = new MethodsField; dynamic_cast<MethodsField*>(A)->methods.push_back(B);}
methods_field(A) ::= . {A = nullptr;}
sub_program(A)::= method_type(B) ID(C) OPENPAR params(D) CLOSEPAR block. {A = new Method(B, C->toString(), D, nullptr); }
method_type(A) ::= type(B). {A = B;}
method_type(A) ::= KWVOID. {A = new VoidType();}

params(A) ::= params(B) COMMA type(C) ID(D). {A = B; dynamic_cast<Parameters*>(A)->params.push_back(new Param(C,D->toString()));}
params(A) ::= type(B) ID(C). {A = new Parameters; dynamic_cast<Parameters*>(A)->params.push_back(new Param(B,C->toString()));}
params(A) ::= . {A = nullptr;}

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

lvalue(A) ::= ID(B). { A = B; }
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
expr ::= lvalue. {}
expr ::= CHAR_CONST.{}
expr ::= method_call. {}
expr ::= OPENPAR expr CLOSEPAR. {}