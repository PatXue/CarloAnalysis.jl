module Plotting

export generate_plot!

using CarloAnalysis
using CairoMakie
using DataFrames

function generate_plot!(ax::Axis, xs, ys; dots=true, line=true, errors=true, label="")
    vals = try
        getfield.(ys, :val)
    catch e
        if isa(e, FieldError)
            errors = false
            collect(ys)
        end
    end
    if dots
        scatter!(ax, xs, vals; label)
    end
    if line
        lines!(ax, xs, vals)
    end
    if errors
        errs = getfield.(ys, :err)
        errorbars!(ax, xs, vals, errs)
    end
end

function generate_plot!(ax::Axis, x, y, data::AbstractDataFrame; kwargs...)
    generate_plot!(ax, data[:, x], data[:, y]; kwargs...)
end

function generate_plot!(ax::Axis, x, y, grouped_data::GroupedDataFrame; label=identity, kwargs...)
    for key in keys(grouped_data)
        data = grouped_data[key]
        generate_plot!(ax, x, y, data; kwargs..., label="$(label(NamedTuple(key)))")
    end
end

function generate_plot!(ax::Axis, x, y, groups, data::DataFrame; kwargs...)
    generate_plot!(ax, x, y, groupby(data, groups); kwargs...)
end


# Apply a function transformation to the data before plotting
function generate_plot!(f::Function, ax::Axis, xs, ys; kwargs...)
    g = v -> f(v...)
    generate_plot!(ax, xs, g.(eachrow(ys)); kwargs...)
end

function generate_plot!(f::Function, ax::Axis, x, y, data::AbstractDataFrame; kwargs...)
    generate_plot!(f, ax, data[:, x], data[:, y]; kwargs...)
end

function generate_plot!(f::Function, ax::Axis, x, y, grouped_data::GroupedDataFrame; kwargs...)
    for key in keys(grouped_data)
        data = grouped_data[key]
        generate_plot!(f, ax, x, y, data; label="$(NamedTuple(key))", kwargs...)
    end
end

function generate_plot!(f::Function, ax::Axis, x, y, groups, data::DataFrame; kwargs...)
    generate_plot!(f, ax, x, y, groupby(data, groups); kwargs...)
end

end