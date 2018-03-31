%{
open Ast_modal

%}

%token SEMICOLON
%token LPAR RPAR
%token Diamond Boxe
%token TRUE FALSE
%token EOF
%token Conj
%token Dij
%token Impl
%token Equiv
%token Not
%token BEGIN END
%token <int> Prop

%right Conj
%right Dij
%right Impl
%right Equiv
%nonassoc Boxe Diamond Not

%start file
%type <Ast_modal.formula> file

%%

file :
| BEGIN; f = formulas ;END; EOF {f}

formulas:
| f1 = formula; SEMICOLON; f2 = formulas {Ast_modal.Conj (f1, f2)}
| f = formula {f}

formula:
| TRUE {Ast_modal.True}
| FALSE {Ast_modal.False}
| f = atom {f}
| Not; f = formula {Ast_modal.Not f}
| f1 = formula; Conj; f2 = formula {Ast_modal.Conj (f1,f2)}
| f1 = formula; Dij; f2 = formula {Ast_modal.Dij (f1,f2)}
| f1 = formula; Impl; f2 = formula {Ast_modal.Impl (f1,f2)}
| f1 = formula; Equiv; f2 = formula
    {Ast_modal.Conj (Ast_modal.Impl (f1,f2),
                     Ast_modal.Impl (f2,f1))}
| Boxe; f = formula {Ast_modal.Boxe f}
| Diamond; f = formula {Ast_modal.Diamond f}

atom:
| LPAR; f = formula; RPAR {f}
| i = Prop; {Ast_modal.Atom i}
