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

%start <string Ast.t list> terms
%%

op_result:
  | "-";                              { Ast.Exclude }
  | "+";                              { Ast.Include }

standard_term:
  | ".."; values= separated_nonempty_list(" ", STRING)
                                      { Ast.ends_with_in_order values }
  | values= separated_nonempty_list(" ", STRING); ".."
                                      { Ast.begins_with_in_order values }
  | values= separated_nonempty_list(" ", STRING)
                                      { Ast.contains_in_order values }
  | ".."; values= separated_nonempty_list(" ", Q_STRING)
                                      { Ast.ends_with_in_order values }
  | ".."; values= separated_nonempty_list(" ", Q_STRING); ".."
                                      { Ast.contains_in_order values }
  | values= separated_nonempty_list(" ", Q_STRING); ".."
                                      { Ast.begins_with_in_order values }
  | value= Q_STRING;                  { Ast.exact value }

%inline value_term:
  | " "*; term= standard_term         { term }

%inline key_term:
  | " "*; term= standard_term         { term }

term:
  | result= op_result; key= key_term; ":"; value= value_term
                                      { Ast.pair_filter result key value }
  | result= op_result; key= key_term; ":"
                                      { Ast.key_filter result key }
  | result= op_result; value= value_term
                                      { Ast.value_filter  result value }
  | key= key_term; ":"; value= value_term
                                      { Ast.pair_filter Include key value }
  | key= key_term; ":"                { Ast.key_filter Include key }
  | ":"; value= value_term            { Ast.value_filter Include value }
  | value= value_term                 { Ast.value_filter Include value }

value_lst:
  | lst= separated_nonempty_list(",", term); EOF
                                      { lst }
terms:
  | " "*; EOF                         { [] }
  | " "*; ","+; EOF                   { [] }
  | lst= value_lst; " "?; ","*; EOF   { lst }
