/-
Copyright (c) 2022 Mario Carneiro. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mario Carneiro
-/
import Std.Tactic.NoMatch
import Std.Data.List.Init.Lemmas

/-!
## Bootstrapping definitions about arrays

This file contains some definitions in `Array` needed for `Std.List.Basic`.
-/

namespace Array

/-- Like `as.toList ++ l`, but in a single pass. -/
@[inline] def toListAppend (as : Array α) (l : List α) : List α :=
  as.foldr List.cons l

/--
`ofFn f` with `f : Fin n → α` returns the list whose ith element is `f i`.
```
ofFn f = #[f 0, f 1, ... , f(n - 1)]
``` -/
def ofFn {n} (f : Fin n → α) : Array α := go 0 (mkEmpty n) where
  /-- Auxiliary for `ofFn`. `ofFn.go f i acc = acc ++ #[f i, ..., f(n - 1)]` -/
  go (i : Nat) (acc : Array α) : Array α :=
    if h : i < n then go (i+1) (acc.push (f ⟨i, h⟩)) else acc
termination_by _ => n - i
