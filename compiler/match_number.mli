module T : sig
  type t

  val pp : Format.formatter -> t -> unit
  val show : t -> string
  val equal : t -> t -> bool
  val compare : t -> t -> int
  val of_int : int -> t
  val of_float : float -> t
  val of_string : string -> t
end

type t = T.t

val pp : Format.formatter -> t -> unit
val show : t -> string
val equal : t -> t -> bool
val compare : t -> t -> int

type op =
  | ExactNumber of t
  | LessThanNumber of t
  | GreaterThanNumber of t
  | BetweenNumber of t * t

val pp_op : Format.formatter -> op -> unit
val show_op : op -> string
val equal_op : op -> op -> bool
val check_match : t -> op -> bool
