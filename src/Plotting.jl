module Plotting

export generate_plot!

using CarloAnalysis
using CairoMakie
using DataFrames

function generate_plot!(ax::Axis, x, y, datasets::Vararg{AbstractDataFrame}; line=true)
    for data in datasets
        xs = data[:, x]
        vals = getfield.(data[:, y], :val)
        errs = getfield.(data[:, y], :err)
        scatter!(ax, xs, vals)
        if line
            lines!(ax, xs, vals)
        end
        errorbars!(ax, xs, vals, errs)
    end
end

function generate_plot!(ax::Axis, x, y, grouped_data::GroupedDataFrame; line=true)
    for key in keys(grouped_data)
        data = grouped_data[key]
        xs = data[:, x]
        vals = getfield.(data[:, y], :val)
        errs = getfield.(data[:, y], :err)
        scatter!(ax, xs, vals, label="$key")
        if line
            lines!(ax, xs, vals)
        end
        errorbars!(ax, xs, vals, errs)
    end
    axislegend(ax)
end

function generate_plot!(ax::Axis, x, y, groups, data::DataFrame; line=true)
    generate_plot!(ax, x, y, groupby(data, groups); line)
end

function generate_plot!(ax::Axis, x, y, results::Vararg{JobResult}; line=true)
    generate_plot!(ax, x, y, getfield.(results, :data)...; line)
end

end