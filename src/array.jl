issettable(a::AbstractArray) = error("It is not known if $(typeof(a)) is settable")
issettable(::Array) = true
issettable(::BitArray) = true
issettable(::AbstractRange) = false
issettable(::LinearIndices) = false
issettable(::CartesianIndices) = false
issettable(a::SubArray) = issettable(parent(a))
issettable(a::PermutedDimsArray) = issettable(parent(a))
issettable(a::Base.ReinterpretArray) = issettable(parent(a))
issettable(a::Base.ReshapedArray) = issettable(parent(a))
issettable(::SparseVector) = true
issettable(::SparseMatrixCSC) = true

struct FrozenArray{T, N, A <: AbstractArray{T, N}} <: AbstractArray{T, N}
    a::A
end

Base.parent(a::FrozenArray) = a.a
Base.length(a::FrozenArray) = length(parent(a))
Base.size(a::FrozenArray) = size(parent(a))
Base.axes(a::FrozenArray) = axes(parent(a))
Base.@propagate_inbounds Base.getindex(a::FrozenArray, i...) = getindex(parent(a), i...)
issettable(a::FrozenArray) = false

function freeze(a::AbstractArray)
    if issettable(a)
        return FrozenArray{eltype(a), ndims(a), typeof(a)}(a)
    else
        return a
    end
end

function thaw(a::AbstractArray)
    if issettable(a)
        return a
    else
        out = similar(a)
        copy!(out, a)
        return out
    end
end

thaw(a::FrozenArray) = parent(a) # DECISION: Perhaps we want the defensive copy? Wait for the compiler to reason about this for `Array`?
