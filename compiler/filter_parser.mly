%start <Fex.t list option> prog
%%

prog:
  | EOF           { None }
  | v = value_lst { Some v }

op_result:
  | MINUS;                            { Fex.Exclude }
  | PLUS;                             { Fex.Include }

value_term:
  | DOTDOT; value= STRING             { Fex.(EndsWith value) }
  | value= STRING; DOTDOT             { Fex.(BeginsWith value) }
  | value= STRING;                    { Fex.(Contains value) }

term:
  | result= op_result; key= STRING; COLON; value= value_term 
                                      { Fex.(PairFilter (result, Contains key, value)) }
  | result= op_result; key= STRING; COLON;               
                                      { Fex.(KeyFilter (result, Contains key)) }
  | result= op_result; value= value_term; 
                                      { Fex.(ValueFilter (result, value)) }
  | key= STRING; COLON; value= value_term 
                                      { Fex.(PairFilter (Include, Contains key, value)) }
  | key= STRING; COLON;               { Fex.(KeyFilter (Include, Contains key)) }
  | value= value_term;                { Fex.(ValueFilter (Include, value)) }

value_lst: 
  | lst= separated_nonempty_list(COMMA, term); EOF { lst }
