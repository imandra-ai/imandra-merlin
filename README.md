# Imandra-merlin

A simple reader using [merlin-extend](https://github.com/let-def/merlin-extend)
and Imandra's `Syntax` module.

# Usage
Install `imandra-merlin` using `opam pin add git@github.com:AestheticIntegration/imandra-merlin.git`

Add `FLG -reader imandra -open Imandra_prelude` to your `.merlin` file (or configure your merlin extension to do the equivalent)

# Troubleshoot

If trying to use `imandra-merlin` causes `merlin` to fail with `EOF exception`, you might need to:

```
opam pin add https://github.com/bronsa/merlin.git\#merlin-extend
ln -s `which ocamlmerlin-imandra` /usr/local/bin
```
