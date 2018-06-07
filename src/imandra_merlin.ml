
module L = Imandra_lib
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
    structure (L.Syntax.implementation buf)

  let for_completion t _pos =  {complete_labels=true}, parse t

  let parse_line t pos line =
    let buf = Lexing.from_string line in
    structure (L.Syntax.implementation buf)

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

  let print_outcome ppf =
    let module P = Oprint in
    function
    | Out_value x ->
      !P.out_value ppf (From_current.copy_out_value x)
    | Out_type x ->
      !P.out_type ppf (From_current.copy_out_type x)
    | Out_class_type x ->
      !P.out_class_type ppf (From_current.copy_out_class_type x)
    | Out_module_type x ->
      !P.out_module_type ppf (From_current.copy_out_module_type x)
    | Out_sig_item x ->
      !P.out_sig_item ppf (From_current.copy_out_sig_item x)
    | Out_signature x ->
      !P.out_signature ppf (List.map From_current.copy_out_sig_item x)
    | Out_type_extension x ->
      !P.out_type_extension ppf (From_current.copy_out_type_extension x)
    | Out_phrase x ->
      !P.out_phrase ppf (From_current.copy_out_phrase x)
end



let () =
  let open Extend_main in
  extension_main
    ~reader:(Reader.make_v0 (module Imandra_reader : V0))
    (Description.make_v0 ~name:"imandra" ~version:"0.1")
