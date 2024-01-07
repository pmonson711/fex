module T : sig
  type t = string

  val pp : Format.formatter -> t -> unit
  val show : t -> string
  val equal : t -> t -> bool
end

type t = T.t

val pp : Format.formatter -> t -> unit
val show : t -> string
val equal : t -> t -> bool
val compare : t -> t -> int

type op =
  | ExactString of string
  | ContainsString of string list
  | BeginsWithString of string list
  | EndsWithString of string list

val pp_op : Format.formatter -> op -> unit
val show_op : op -> string
val equal_op : op -> op -> bool
val check_match : t -> op -> bool
