%token <string> STRING
%token <string> Q_STRING
%token COLON ":"
%token COMMA ","
%token DOTDOT ".."
%token MINUS "-"
%token PLUS "+"
%token SPACE " "
(* %token AND *)
(* %token OR *)
%token EOF

%start <Ast.t list> terms
%%

op_result:
  | "-";                              { Ast.Exclude }
  | "+";                              { Ast.Include }

standard_term:
  | ".."; value= separated_nonempty_list(" ", STRING)
                                      { Ast.(EndsWith value) }
  | value= separated_nonempty_list(" ", STRING); ".."
                                      { Ast.(BeginsWith value) }
  | value= separated_nonempty_list(" ", STRING)
                                      { Ast.(Contains value) }
  | ".."; value= separated_nonempty_list(" ", Q_STRING)
                                      { Ast.(EndsWith value) }
  | ".."; value= separated_nonempty_list(" ", Q_STRING); ".."
                                      { Ast.(Contains value) }
  | value= separated_nonempty_list(" ", Q_STRING); ".."
                                      { Ast.(BeginsWith value) }
  | value= Q_STRING;                  { Ast.(Exact value) }

%inline value_term:
  | " "?; term= standard_term         { term }

%inline key_term:
  | " "?; term= standard_term         { term }

term:
  | result= op_result; key= key_term; ":"; value= value_term
                                      { Ast.(PairFilter (result, key, value)) }
  | result= op_result; key= key_term; ":"
                                      { Ast.(KeyFilter (result, key)) }
  | result= op_result; value= value_term
                                      { Ast.(ValueFilter (result, value)) }
  | key= key_term; ":"; value= value_term
                                      { Ast.(PairFilter (Include, key, value)) }
  | key= key_term; ":"                { Ast.(KeyFilter (Include, key)) }
  | ":"; value= value_term            { Ast.(ValueFilter (Include, value)) }
  | value= value_term                 { Ast.(ValueFilter (Include, value)) }

value_lst:
  | lst= separated_nonempty_list(",", term); EOF
                                      { lst }

terms:
  | " "*; EOF                         { [] }
  | " "?; ","+; EOF                   { [] }
  | lst= value_lst; " "?; ","*; EOF { lst }
