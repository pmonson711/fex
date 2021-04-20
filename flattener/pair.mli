(** {1 Overview}

    The Pair module is designed to be based on nothing but polymorphic
    variants and built in types. This allows the basic Pair type to be used
    without a reference to the flattener library.
*)

module JsonPrimatives : sig
  type t =
    [ `Null
    | `Bool   of bool
    | `Int    of int
    | `Intlit of string
    | `Float  of float
    | `String of string
    ]
end

type t = [ `Pair of key * value ] [@@deriving show, eq]
(** Tagged pair of keys and values *)

and key = [ `Key of string ] [@@deriving show, eq]
(** Tagged string to represent a key in a key-value pair *)

and value = [ `Value of JsonPrimatives.t ] [@@deriving show, eq]
(** Tagged string to represent a value in a key-value pair *)

module StringPair : sig
  type t = [ `Pair of key * value ] [@@deriving show, eq]
  (** Tagged pair of keys and values *)

  and key = [ `Key of string ] [@@deriving show, eq]
  (** Tagged string to represent a key in a key-value pair *)

  and value = [ `Value of [ `String of string ] ] [@@deriving show, eq]
  (** Tagged string to represent a value in a key-value pair *)
end

(** {1 String Operations}

    Functions to build [key]s, [value]s, and [pair]s.
    *)

val key_of_string : string -> key
(** [key_of_string k] Build a key from a string with the value of [v] *)

val value_of_string : string -> StringPair.value
(** [value_of_string v] Build a value from a string with the value of [v] *)

val of_strings : string -> string -> StringPair.t
(** [of_strings k v] Build a pair from k and v such that the key is [k] and the value is [v] *)

(** {1 Converters} *)

val to_string_tuple : StringPair.t -> string * string
(** [to_string_tuple pair] converts a pair to a simple tuple of strings *)
