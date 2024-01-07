module T = struct
  type t = string * int * float option [@@deriving show]

  let equal (_, i1, rf1) (_, i2, rf2) = i1 = i2 && rf1 = rf2
  let compare (_, i1, rf1) (_, i2, rf2) = compare (i1, rf1) (i2, rf2)
  let of_int i = (string_of_int i, i, None)

  let of_float f =
    if Float.is_integer f then (Float.to_string f, Float.to_int f, None)
    else (Float.to_string f, Float.to_int f, Some (f -. Float.trunc f))

  let of_string s =
    let _, i, rf = of_float @@ Float.of_string s in
    (String.trim s, i, rf)
end

type t = T.t [@@deriving show, eq, ord]

type op =
  | ExactNumber of t
  | LessThanNumber of t
  | GreaterThanNumber of t
  | BetweenNumber of t * t
[@@deriving show, eq]

let check_match (from_input : t) (match_op : op) : bool =
  match match_op with
  | ExactNumber expected -> T.compare from_input expected == 0
  | LessThanNumber lower -> T.compare lower from_input == 1
  | GreaterThanNumber upper -> T.compare from_input upper == 1
  | BetweenNumber (lower, upper) ->
      T.compare from_input upper == -1 && T.compare lower from_input == -1
