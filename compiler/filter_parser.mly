%token <string> STRING
%token <string> Q_STRING
%token <float> FLOAT
%token COLON ":"
%token COMMA ","
%token DOTDOT ".."
%token MINUS "-"
%token PLUS "+"
%token SPACE " "
%token EQUAL "="
%token L_ANGLE "<"
%token R_ANGLE ">"
%token EOF

%start <string Ast.t list> terms
%%

op_result:
  | "-";                              { Ast.Exclude }
  | "+";                              { Ast.Include }

%inline string_list:
  | values= separated_nonempty_list(" ", STRING) 
                                      { values }
  | f= FLOAT; values= separated_nonempty_list(" ", STRING) 
                                      { (string_of_float f) :: values }

%inline q_string_list:
  | values= separated_nonempty_list(" ", Q_STRING) { values }

standard_term:
  | ".."; values= string_list         { Ast.ends_with_in_order values }
  | values= string_list; ".."         { Ast.begins_with_in_order values }
  | values= string_list               { Ast.contains_in_order values }
  | ".."; values= q_string_list       { Ast.ends_with_in_order values }
  | ".."; values= q_string_list; ".." { Ast.contains_in_order values }
  | values= q_string_list; ".."       { Ast.begins_with_in_order values }
  | value= Q_STRING;                  { Ast.exact value }

number:
  | f= FLOAT                          { f }

number_value_term:
  | "<"; f= number;             { Ast.less_than_of_float f }
  | ">"; f= number;             { Ast.greater_than_of_float f }
  | "="; f= number;             { Ast.exact_of_float f }
  | l= number; " "*; ".."; h= number 
                                      { Ast.between_of_float l h }

%inline value_term:
  | " "*; term= standard_term         { term }
  | " "*; term= number_value_term     { term }

%inline key_term:
  | " "*; term= standard_term         { term }

term:
  | result= op_result; key= key_term; ":"; value= value_term
                                      { Ast.pair_filter result key value }
  | result= op_result; key= key_term; ":"
                                      { Ast.key_filter result key }
  | result= op_result; value= value_term
                                      { Ast.value_filter result value }
  | key= key_term; ":"; value= value_term
                                      { Ast.pair_filter Ast.inc key value }
  | key= key_term; ":"                { Ast.key_filter Ast.inc key }
  | ":"; value= value_term            { Ast.value_filter Ast.inc value }
  | value= value_term                 { Ast.value_filter Ast.inc value }

value_lst:
  | lst= separated_nonempty_list(",", term); EOF
                                      { lst }
terms:
  | " "*; EOF                         { [] }
  | " "*; ","+; EOF                   { [] }
  | lst= value_lst; " "?; ","*; EOF   { lst }
