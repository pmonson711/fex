%start <Fex.t list option> prog
%%

prog:
  | SPACE?; EOF   { None }
  | v = value_lst { Some v }

op_result:
  | MINUS;                            { Fex.Exclude }
  | PLUS;                             { Fex.Include }

standard_term:
  | DOTDOT; value= STRING             { Fex.(EndsWith value) }
  | value= STRING; DOTDOT             { Fex.(BeginsWith value) }
  | value= STRING;                    { Fex.(Contains value) }
  | DOTDOT; value= Q_STRING;          { Fex.(EndsWith value) }
  | DOTDOT; value= Q_STRING; DOTDOT   { Fex.(Contains value) }
  | value= Q_STRING; DOTDOT           { Fex.(BeginsWith value) }
  | value= Q_STRING;                  { Fex.(Exact value) }

value_term:
  | SPACE?; result= standard_term; SPACE?
                                      { result }

key_term:
  | SPACE?; result= standard_term; SPACE?
                                      { result }

term:
  | SPACE?; result= op_result; key= key_term; COLON; value= value_term
                                      { Fex.(PairFilter (result, key, value)) }
  | SPACE?; result= op_result; key= key_term; COLON;
                                      { Fex.(KeyFilter (result, key)) }
  | SPACE?; result= op_result; value= value_term;
                                      { Fex.(ValueFilter (result, value)) }
  | key= key_term; COLON; value= value_term
                                      { Fex.(PairFilter (Include, key, value)) }
  | key= key_term; COLON;             { Fex.(KeyFilter (Include, key)) }
  | value= value_term;                { Fex.(ValueFilter (Include, value)) }

value_lst:
  | lst= separated_nonempty_list(COMMA, term); EOF
                                      { lst }
