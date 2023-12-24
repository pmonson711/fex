val match_operation : string Ast.match_type -> Ast.match_operation -> bool
val string_match_operation : string -> Ast.string_match_operation -> bool
val number_match_operation : Ast.number -> Ast.number_match_operation -> bool

module T : sig
  type t = string

  val pp : Format.formatter -> t -> unit
  val show : t -> string
  val equal : t -> t -> bool
end
