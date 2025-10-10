module Plotting

export generate_plot

using CarloAnalysis
using CairoMakie
using DataFrames

function generate_plot(fig::Figure, x, y, datasets::Vararg{AbstractDataFrame};
                       xlabel="", ylabel="", title="", line=true)
    if xlabel == ""
        xlabel = "$x"
    end
    if ylabel == ""
        ylabel = "$y"
    end
    if title == ""
        title = "$y vs. $x"
    end

    ax = Axis(fig; title, xlabel, ylabel)
    for data in datasets
        vals = getfield.(data[:, y], :val)
        errs = getfield.(data[:, y], :err)
        scatter!(data[:, x], vals)
        if line
            lines!(data[:, x], vals)
        end
        errorbars!(data[:, x], vals, errs)
    end

    return ax
end

function generate_plot(fig::Figure, result::JobResult, x, y;
                       xlabel="", ylabel="", title="", line=true)
    generate_plot(fig, x, y, result.data; xlabel, ylabel, title, line)
end

end