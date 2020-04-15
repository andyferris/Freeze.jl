# Freeze.jl

A minimal package to expose an interface for reasoning about and controlling the mutability
of indexable containers, via:

 * `issettable(x)` returns a `Bool` indicating whether `setindex!` works on `x`.
 * `freeze(x)` returns a container with the values contained within `x` that cannot be mutated via `setindex!`.
 * `thaw(x)` is the reverse of `freeze`, returning a container with the values contained with `x` that can be mutated via `setindex!`.

In the general case, the above might require copying the contents of `x`, but in practice we
expect the Julia compiler to become good at reasoning about the lifetime of objects via escape
analysis (as it can already do for structs). 

NOTE: The current implementation here for `AbstractArray` might be unsound because it does not perform defensive copying! This package provides interface guarantees around `setindex!` only - actual values may mutate if the underlying data structures are accessed directly. It may be useful for experimentation or preventing some varieties of bugs.

See also `Base.Experimental.Const` in Julia 1.3 onwards, and the [ArrayInterface.jl](https://github.com/SciML/ArrayInterface.jl) package.