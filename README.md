# Imandra-merlin

A simple reader using [merlin-extend](https://github.com/let-def/merlin-extend)
and Imandra's `Syntax` module.

# Usage
Install `imandra-merlin` using `opam pin add git@github.com:AestheticIntegration/imandra-merlin.git`

For the OCaml extension, add `FLG -reader imandra -package imandra-base.prelude -open Imandra_prelude` to your `.merlin` file (or configure your merlin extension to do the equivalent).

For the Reason extension add `FLG -reader imandra-reason -package imandra-base.prelude -open Imandra_prelude` to your `.merlin` file (or configure your merlin extension to do the equivalent).



# Troubleshoot

If trying to use `imandra-merlin` causes `merlin` to fail with `EOF exception`, you might need to:

```
opam pin add https://github.com/Aestheticintegration/merlin.git
ln -s `which ocamlmerlin-imandra` /usr/local/bin
```
