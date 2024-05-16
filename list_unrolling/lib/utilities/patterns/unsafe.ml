open Codelib;;
open Fun_rebind;;
open Common;;

(* Unsafe first-class pattern generation *)

type ('a, 'r) unsafe_pat = ('a, unit, 'r) pat

let unsafe_loosen (p : ('a, 'f, 'r) pat) : ('a, 'r) unsafe_pat = Obj.magic p
let unsafe_tighten (p : ('a, 'r) unsafe_pat) : ('a, 'f, 'r) pat = Obj.magic p

(* Safe-wrapped unsafe first-class pattern generation *)

type ('a, 'r) unsafe_patwrap = Pat : ('a list, 'f, 'r) pat * 'f code -> ('a, 'r) unsafe_patwrap

let modify_fun_body : 'f code -> ('a -> 'r -> 'r) code -> 'a code -> 'f code = fun c pp a ->
  let rec dec_app : Parsetree.expression -> Parsetree.expression = fun x -> match x.pexp_desc with
    | Parsetree.Pexp_fun(Nolabel, None, p, e) -> Ast_helper.Exp.fun_ Nolabel None p (dec_app e)
    | _ -> apply_fun (apply_fun (reduce_code pp) (reduce_code a)) x
in promote_code (dec_app (reduce_code c))