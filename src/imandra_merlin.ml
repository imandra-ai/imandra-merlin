
module Syn = Imandra_syntax.Syntax
module OMP = Migrate_parsetree

open Extend_protocol.Reader

module Imandra_reader = struct
  type t = buffer

  let load buffer = buffer

  module To_current = OMP.Convert(OMP.OCaml_403)(OMP.OCaml_current)
  module From_current = OMP.Convert(OMP.OCaml_current)(OMP.OCaml_403)

  let structure str =
    Structure (To_current.copy_structure str)

  let signature sg =
    Signature (To_current.copy_signature sg)

  let parse {text; path} =
    let buf = Lexing.from_string text in
    Location.init buf (Filename.basename path);
    structure (Syn.implementation buf)

  let for_completion t _pos =  {complete_labels=true}, parse t

  let parse_line t pos line =
    let buf = Lexing.from_string line in
    structure (Syn.implementation buf)

  let ident_at t _ = []

  let pretty_print ppf =
    let module P = Pprintast in
    let formatter = P.default in
    function
    | Pretty_core_type x ->
      formatter#core_type ppf (From_current.copy_core_type x)
    | Pretty_case_list x ->
      formatter#case_list ppf (List.map From_current.copy_case x)
    | Pretty_expression x ->
      formatter#expression ppf (From_current.copy_expression x)
    | Pretty_pattern x ->
      formatter#pattern ppf (From_current.copy_pattern x)
    | Pretty_signature x ->
      formatter#signature ppf (From_current.copy_signature x)
    | Pretty_structure x ->
      formatter#structure ppf (From_current.copy_structure x)
    | Pretty_toplevel_phrase x ->
      formatter#toplevel_phrase ppf (From_current.copy_toplevel_phrase x)

  let print_outcome = Extend_helper.print_outcome_using_oprint
end



let () =
  let open Extend_main in
  extension_main
    ~reader:(Reader.make_v0 (module Imandra_reader : V0))
    (Description.make_v0 ~name:"imandra" ~version:"0.1")
