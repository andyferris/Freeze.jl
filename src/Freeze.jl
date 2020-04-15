"""
# Freeze.jl

A minimal package to expose an interface for reasoning about and controlling the mutability
of indexable containers, via:

 * `issettable(x)` returns a `Bool` indicating whether `setindex!` works on `x`.
 * `freeze(x)` returns a container with the values contained within `x` that cannot be mutated via `setindex!`.
 * `thaw(x)` is the reverse of `freeze`, returning a container with the values contained with `x` that can be mutated via `setindex!`.

In the general case, the above might require copying the contents of `x`, but in practice we
expect the Julia compiler to be good at reasoning about the lifetime of objects via escape
analysis.
"""
module Freeze

using SparseArrays

export issettable, freeze, thaw
export FrozenArray

"""
    issettable(container)

Return `true` if `setindex!` works on `container`, or `false` otherwise.
"""
function issettable end

"""
    freeze(container)

Freeze an indexable container to make it immutable. Disables the usage of `setindex!`.

See also `thaw`.
"""
function freeze end

"""
    thaw(container)

Thaw an indexable container to make it mutable. Enables the usage of `setindex!`.

See also `freeze`.
"""
function thaw end

include("array.jl")

end # module
