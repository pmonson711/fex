%start <Ast.t list option> prog
%%

prog:
  | SPACE?; EOF                       { None }
  | v = value_lst                     { Some v }

op_result:
  | MINUS;                            { Ast.Exclude }
  | PLUS;                             { Ast.Include }

standard_term:
  | DOTDOT; value= separated_nonempty_list(SPACE, STRING)
                                      { Ast.(EndsWith value) }
  | value= separated_nonempty_list(SPACE, STRING); DOTDOT
                                      { Ast.(BeginsWith value) }
  | value= separated_nonempty_list(SPACE, STRING)
                                      { Ast.(Contains value) }
  | DOTDOT; value= separated_nonempty_list(SPACE, Q_STRING)
                                      { Ast.(EndsWith value) }
  | DOTDOT; value= separated_nonempty_list(SPACE, Q_STRING); DOTDOT
                                      { Ast.(Contains value) }
  | value= separated_nonempty_list(SPACE, Q_STRING); DOTDOT
                                      { Ast.(BeginsWith value) }
  | value= Q_STRING;                  { Ast.(Exact value) }

value_term:
  | SPACE?; term= standard_term       { term }

key_term:
  | SPACE?; term= standard_term       { term }

term:
  | SPACE?; result= op_result; key= key_term; COLON; value= value_term
                                      { Ast.(PairFilter (result, key, value)) }
  | SPACE?; result= op_result; key= key_term; COLON
                                      { Ast.(KeyFilter (result, key)) }
  | SPACE?; result= op_result; value= value_term
                                      { Ast.(ValueFilter (result, value)) }
  | key= key_term; COLON; value= value_term
                                      { Ast.(PairFilter (Include, key, value)) }
  | key= key_term; COLON              { Ast.(KeyFilter (Include, key)) }
  | value= value_term                 { Ast.(ValueFilter (Include, value)) }

value_lst:
  | lst= separated_nonempty_list(COMMA, term); EOF
                                      { lst }
