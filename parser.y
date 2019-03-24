%include {
    #include <assert.h>
    #include <iostream>
    #include "decaf_ast.h"

    extern int lineno;
}

%token_type {ASTNode*}
%start_symbol program

%syntax_error {
    int n = sizeof(yyTokenName) / sizeof(yyTokenName[0]);
        for (int i = 0; i < n; ++i) {
                int a = yy_find_shift_action(yypParser, (YYCODETYPE)i);
                if (a < YYNSTATE + YYNRULE) {
                        printf("possible token: %s\n", yyTokenName[i]);
                }
        }
    std::cout << "Syntax error at line " << lineno << std::endl;
    exit(1);
}

%parse_failure {
    fprintf(stderr,"Giving up.  Parser is hopelessly lost...\n");
}

program ::= KWCLASS ID(A) OPENCUR field_decl(B) methods_field(C) CLOSECUR. { 
                                                                                //std::cout << "PARSER COMPLETED!!!\n"; 
                                                                                auto prog = new Program(A->toString(),B,C);
                                                                                //std::cout << prog->toString() << std::endl;
                                                                                prog->load_symbols(nullptr); 
                                                                                prog->check_sem(nullptr);
                                                                                if(getCountErr())
                                                                                    prog->gencode(nullptr);
                                                                            }
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
sub_program(A)::= method_type(B) ID(C) OPENPAR params(D) CLOSEPAR block(E). {A = new Method(B, C->toString(), D, E); }
method_type(A) ::= type(B). {A = B;}
method_type(A) ::= KWVOID. {A = new VoidType();}

params(A) ::= params(B) COMMA type(C) ID(D). {A = B; dynamic_cast<Parameters*>(A)->params.push_back(new Param(C,D->toString()));}
params(A) ::= type(B) ID(C). {A = new Parameters; dynamic_cast<Parameters*>(A)->params.push_back(new Param(B,C->toString()));}
params(A) ::= . {A = nullptr;}

block(A) ::= OPENCUR field_decl(B) statements(C) CLOSECUR. {A = C; dynamic_cast<BlockStatement*>(A)->decl_field = B;}

statements(A) ::= statements(B) statement(C). {A=B; dynamic_cast<BlockStatement*>(B)->stmts.push_back(C);}
statements(A) ::= statement(B). {A = new BlockStatement; dynamic_cast<BlockStatement*>(A)->stmts.push_back(B);}
statements(A) ::= . {A = new BlockStatement;}

statement(A) ::= assign(B) SEMICOLON. {A = B;}
statement(A) ::= method_call(B) SEMICOLON. {A = B;}
statement(A) ::= if_st(B). {A = B;}
statement(A) ::= while(B). {A = B;}
statement(A) ::= KWRETURN expr(B) SEMICOLON. {A = new ReturnStatement(B);}
statement(A) ::= KWRETURN SEMICOLON. {A = new ReturnStatement(nullptr);}
statement(A) ::= KWBREAK SEMICOLON. {A = new BreakStatement;}
statement(A) ::= KWCONTINUE SEMICOLON. {A = new ContinueStatement;}
statement(A) ::= for_st(B). {A = B;}
statement(A) ::= block(B). {A = B;}

assign(A) ::= lvalue(B) OPASSIGN expr(C). {A = new AssignStatement(B,C);}

method_call(A) ::= ID(I) OPENPAR exprs_list(B) CLOSEPAR. {A = new MethodCallStatement(I->toString(), B);}
method_call(A) ::= SOP OPENPAR arguments(B) CLOSEPAR. {A = new MethodCallStatement("SOP",B);}
method_call(A) ::= SOPLN OPENPAR arguments(B) CLOSEPAR. {A = new MethodCallStatement("SOPLN", B);}
method_call(A) ::= SOR OPENPAR CLOSEPAR. {A = new MethodCallStatement("SOR", nullptr);}
method_call(A) ::= RANDOM OPENPAR expr(B) CLOSEPAR. {A = new MethodCallStatement("RANDOM",B);}

if_st(A) ::= KWIF OPENPAR expr(B) CLOSEPAR block(C) opt_else(D). {A = new IfStatement(B,C,D);}
opt_else(A) ::= KWELSE block(B). {A = B;}
opt_else(A) ::= . {A = nullptr;}

while(A) ::= KWWHILE OPENPAR expr(B) CLOSEPAR block(C). {A = new WhileStatement(B,C);}

for_st(A) ::= KWFOR OPENPAR list_assignings(B) SEMICOLON expr(C) SEMICOLON list_assignings(D) CLOSEPAR block(E). {A = new ForStatement(B,C,D,E);}

list_assignings(A) ::= list_assignings(B) COMMA assign(C). {A = B; dynamic_cast<AssigningsStatement*>(A)->assigns.push_back(C);}
list_assignings(A) ::= assign(B). {A = new AssigningsStatement; dynamic_cast<AssigningsStatement*>(A)->assigns.push_back(B);}

exprs_list(A) ::= exprs_list(B) COMMA expr(C). {A = B; dynamic_cast<ExprList*>(A)->exprs.push_back(C);}
exprs_list(A) ::= expr(B). {A = new ExprList; dynamic_cast<ExprList*>(A)->exprs.push_back(B);}
exprs_list(A) ::= . {A = nullptr;}

arguments(A) ::= arguments(B) COMMA argument(C). {A = B; dynamic_cast<ArgumentsList*>(A)->args.push_back(C);}
arguments(A) ::= argument(B). {A = new ArgumentsList; dynamic_cast<ArgumentsList*>(A)->args.push_back(B);}

argument(A) ::= expr(B). {A = B;}
argument(A) ::= STRLIT(B). {A = B;}

%left AND.
%left OR.
%nonassoc EQ NE GT GE LT LE.
%left SHL SHR.
%left MOD.
%left ADD SUB.
%left MUL DIV.
%right NOT NEG.

%type expr {Expr*}
%type method_expr {Expr*}
%type lvalue {Expr*}

lvalue(A) ::= ID(B). { A = dynamic_cast<Expr*>(B); }
lvalue(A) ::= ID(B) OPENBRA expr(C) CLOSEBRA. {A = new LValueIdx(B->toString(), C);}

expr(A) ::= expr(B) AND expr(C). {A= new And_Expr(B, C, "&&"); A->setLinenum(lineno);}
expr(A) ::= expr(B) OR expr(C). {A= new Or_Expr(B, C, "||"); A->setLinenum(lineno);}
expr(A) ::= expr(B) EQ expr(C). {A= new EQ_Expr(B, C, "=="); A->setLinenum(lineno);}
expr(A) ::= expr(B) NE expr(C). {A= new NE_Expr(B, C, "!="); A->setLinenum(lineno);}
expr(A) ::= expr(B) GT expr(C). {A= new GT_Expr(B, C, ">"); A->setLinenum(lineno);}
expr(A) ::= expr(B) GE expr(C). {A= new GE_Expr(B, C, ">="); A->setLinenum(lineno);}
expr(A) ::= expr(B) LT expr(C). {A= new LT_Expr(B, C, "<"); A->setLinenum(lineno);}
expr(A) ::= expr(B) LE expr(C). {A= new LE_Expr(B, C, "<="); A->setLinenum(lineno);}
expr(A) ::= expr(B) SHL expr(C). {A= new SHL_Expr(B, C, "<<"); A->setLinenum(lineno);}
expr(A) ::= expr(B) SHR expr(C). {A= new SHR_Expr(B, C, ">>"); A->setLinenum(lineno);}
expr(A) ::= expr(B) MOD expr(C). {A= new Mod_Expr(B, C, "%"); A->setLinenum(lineno);}
expr(A) ::= expr(B) ADD expr(C). {A= new Add_Expr(B, C, "+"); A->setLinenum(lineno);}
expr(A) ::= expr(B) SUB expr(C). {A= new Sub_Expr(B, C, "-"); A->setLinenum(lineno);}
expr(A) ::= expr(B) MUL expr(C). {A= new Mul_Expr(B, C, "*"); A->setLinenum(lineno);}
expr(A) ::= expr(B) DIV expr(C). {A= new Div_Expr(B, C, "/"); A->setLinenum(lineno);}
expr(A) ::= NOT expr(B). {A = new Not_Expr(B); A->setLinenum(lineno);}
expr(A) ::= NEG expr(B). {A = new Neg_Expr(B); A->setLinenum(lineno);}
expr(A) ::= constant(B). {A = dynamic_cast<Expr*>(B); A->setLinenum(lineno);}
expr(A) ::= lvalue(B). {A = dynamic_cast<Expr*>(B); A->setLinenum(lineno);}
expr(A) ::= CHAR_CONST(B).{A = dynamic_cast<Expr*>(B); A->setLinenum(lineno);}
expr(A) ::= method_expr(B). {A = B; A->setLinenum(lineno);}
expr(A) ::= OPENPAR expr(B) CLOSEPAR. {A = B; A->setLinenum(lineno);}

method_expr(A) ::= ID(B) OPENPAR exprs_list(C) CLOSEPAR. {A = new MethodCallExpr(B->toString(),C);}
method_expr(A) ::= SOR OPENPAR CLOSEPAR. {A = new MethodCallExpr("SOR",nullptr);}
method_expr(A) ::= RANDOM OPENPAR expr(C) CLOSEPAR. {A = new MethodCallExpr("RANDOM",C);}