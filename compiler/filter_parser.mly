%token <string> STRING
%token <string> Q_STRING
%token <string> NUMBER
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

%inline q_string_list:
  | values= separated_nonempty_list(" ", Q_STRING) { values }

key_value:
  | value= STRING                     { value }
  | value= NUMBER                     { String.trim value }
  | R_ANGLE                           { ">" }
  | L_ANGLE                           { "<" }
  | EQUAL                             { "=" }
%inline key_string_list:
  | values= separated_nonempty_list(" ", key_value) 
                                      { values }
key_standard_term:
  | ".."; values= key_string_list     { Ast.ends_with_in_order values }
  | values= key_string_list; ".."     { Ast.begins_with_in_order values }
  | values= key_string_list           { Ast.contains_in_order values }
  | ".."                              { Ast.contains_in_order [".."] }
  | ".."; values= q_string_list       { Ast.ends_with_in_order values }
  | ".."; values= q_string_list; ".." { Ast.contains_in_order values }
  | values= q_string_list; ".."       { Ast.begins_with_in_order values }
  | value= Q_STRING;                  { Ast.exact value }

number:
  | f= NUMBER                         { f }

number_value_term:
  | "<"; f= number;                   { Ast.less_than_of_string f } 
  | ">"; f= number;                   { Ast.greater_than_of_string f }
  | "="; f= number;                   { Ast.exact_of_string f }
  | "="; l= number; ".."; h= number 
                                      { Ast.between_of_string l h } 

%inline value_string_string:
  | value= STRING                     { value }
  | value= NUMBER                     { String.trim value }
  | v1= NUMBER; "+"; v2= NUMBER       { let b = Buffer.create 16 in
                                        Buffer.add_string b (String.trim v1) ;
                                        Buffer.add_char b '+' ;
                                        Buffer.add_string b (String.trim v2) ;
                                        Buffer.contents b
                                      }
  | v1= NUMBER; v2= STRING            { let b = Buffer.create 16 in
                                        Buffer.add_string b (String.trim v1) ;
                                        Buffer.add_string b v2 ;
                                        Buffer.contents b
                                      }

%inline value_string:
  | value= value_string_string        { value }
  | lst= "-"+
                                      { let b = Buffer.create (List.length lst) in 
                                        List.iter (fun () -> Buffer.add_char b '-') lst ;
                                        Buffer.contents b
                                      }
  | lst1= "-"+; lst2= "+"+
                                      { let b = Buffer.create ((List.length lst1) + (List.length lst2)) in 
                                        List.iter (fun () -> Buffer.add_char b '-') lst1 ;
                                        List.iter (fun () -> Buffer.add_char b '+') lst2 ;
                                        Buffer.contents b
                                      }
  | lst= "-"+; value= value_string_string          
                                      { let b = Buffer.create (List.length lst) in 
                                        List.iter (fun () -> Buffer.add_char b '-') lst ;
                                        Buffer.add_string b value ;
                                        Buffer.contents b
                                      }
  | lst= "+"+; value= value_string_string          
                                      { let b = Buffer.create (List.length lst) in 
                                        List.iter (fun () -> Buffer.add_char b '+') lst ;
                                        Buffer.add_string b value ;
                                        Buffer.contents b
                                      }
  | lst= "+"+
                                      { let b = Buffer.create (List.length lst) in 
                                        List.iter (fun () -> Buffer.add_char b '+') lst ;
                                        Buffer.contents b
                                      }
  | lst1= "+"+; lst2= "-"+
                                      { let b = Buffer.create ((List.length lst1) + (List.length lst2)) in 
                                        List.iter (fun () -> Buffer.add_char b '+') lst1 ;
                                        List.iter (fun () -> Buffer.add_char b '-') lst2 ;
                                        Buffer.contents b
                                      }

%inline value_string_2:
  | value= value_string; lst= ":"*
                                      { let b = Buffer.create (List.length lst) in 
                                        Buffer.add_string b value ;
                                        List.iter (fun () -> Buffer.add_char b ':') lst ;
                                        Buffer.contents b
                                      }

%inline value_string_list:
  | values= separated_nonempty_list(" ", value_string_2) 
                                      { values }

value_standard_term:
  | ".."; values= value_string_list   { Ast.ends_with_in_order values }
  | values= value_string_list; ".."   { Ast.begins_with_in_order values }
  | values= value_string_list         { Ast.contains_in_order values }
  | ".."                              { Ast.contains_in_order [".."] }
  | ".."; values= q_string_list       { Ast.ends_with_in_order values }
  | ".."; values= q_string_list; ".." { Ast.contains_in_order values }
  | values= q_string_list; ".."       { Ast.begins_with_in_order values }
  | value= Q_STRING;                  { Ast.exact value }


%inline value_term:
  | " "*; term= value_standard_term   { term }
  | " "*; term= number_value_term     { term }

%inline key_term:
  | " "*; term= key_standard_term     { term }

term:
  | result= op_result; key= key_term; ":"; value= value_term
                                      { Ast.pair_filter result key value }
  | result= op_result; key= key_term; ":"
                                      { Ast.key_filter result key }
  | result= op_result; value= key_term
                                      { Ast.value_filter result value }
  | key= key_term; ":"; value= value_term
                                      { Ast.pair_filter Ast.inc key value }
  | key= key_term; ":"                { Ast.key_filter Ast.inc key }
  | ":"; value= value_term            { Ast.value_filter Ast.inc value }
  | value= key_term                   { Ast.value_filter Ast.inc value }

value_lst:
  | lst= separated_nonempty_list(",", term); EOF
                                      { lst }
terms:
  | " "*; EOF;                        { [] }
  | ","+; lst= value_lst; EOF         { lst }
  | ":"+; ","+; lst= value_lst; EOF   { lst }
  | lst= value_lst; " "?; ","*; EOF   { lst }
