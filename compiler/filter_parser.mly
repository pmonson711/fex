%start <Fex.t list option> prog
%%

prog:
  | EOF           { None }
  | v = value_lst { Some v }

op_result:
  | MINUS;                            { Fex.Exclude }
  | PLUS;                             { Fex.Include }

term:
  | result= op_result; key= STRING; COLON; value= STRING 
                                      { Fex.(PairFilter (result, Contains key, Contains value)) }
  | result= op_result; key= STRING; COLON;               
                                      { Fex.(KeyFilter (result, Contains key)) }
  | result= op_result; value= STRING; { Fex.(ValueFiler (result, Contains value)) }
  | key= STRING; COLON; value= STRING { Fex.(PairFilter (Include, Contains key, Contains value)) }
  | key= STRING; COLON;               { Fex.(KeyFilter (Include, Contains key)) }
  | value= STRING;                    { Fex.(ValueFiler (Include, Contains value)) }

value_lst: 
  | lst= separated_nonempty_list(COMMA, term); EOF { lst }
