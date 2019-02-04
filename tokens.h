enum class Token: int{
    Error,
    Eof,
    Id,
    Num,
    StrLit,
    OpSum, //Operadores
    OpRes,
    OpMul,
    OpDiv,
    OpMeM,
    OpMaM,
    OpMod,
    OpMen,
    OpMay,
    OpMenI,
    OpMayI,
    OpIgual,
    OpDif,
    OpAnd,
    OpOr,
    OpNegar,
    Asignar,
    Semicolon, //Puntuaciones
    Comma,
    OpenPar,
    ClosePar,
    OpenBra,
    CloseBra,
    OpenKey,
    CloseKey,
    KBool, //Keywords
    KBreak,
    KContinue,
    KClass,
    KElse,
    KExtends,
    KFalse,
    KFor,
    KIf,
    KInt,
    KNew,
    KNull,
    KReturn,
    KRot,
    KTrue,
    KVoid,
    KWhile,
};