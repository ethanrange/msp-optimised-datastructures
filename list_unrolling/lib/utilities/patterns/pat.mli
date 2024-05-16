open Codelib;;

type ('a, 'b, 'c) pat = ('a, 'b, 'c) Common.pat

(* Wildcard pattern *)
val __ : ('a, 'r, 'r) pat
(* Integer constant pattern *)
val int : int -> (int, 'r, 'r) pat

(* Variable binding pattern *)
val var : ('a, 'a -> 'r, 'r) pat

(* Binary tuple pattern *)
val ( ** ) : ('a, 'k, 'j) pat -> ('b, 'j, 'r) pat -> ('a * 'b, 'k, 'r) pat

(* Empty and cons list patterns *)
val empty : ('a, 'r, 'r) pat
val ( >:: ) : ('a, 'k, 'j) pat -> ('a list, 'j, 'r) pat -> ('a list, 'k, 'r) pat

(* Pattern - function case pairs *)
type (_, _) case
val (=>) :('a, 'f, 'r) pat -> 'f code -> ('a, 'r) case

(* Function generator *)
val function_ : ('a, 'b) case list -> ('a -> 'b) code

(* Match generator *)
val match_ : ('a code) -> ('a, 'b) case list -> 'b code

(* Safe first-class pattern generation *)

type ('a, 'r) patwrap = Pat : ('a list, 'f, 'r) pat * (('r code -> 'r code) -> 'f code) -> ('a, 'r) patwrap