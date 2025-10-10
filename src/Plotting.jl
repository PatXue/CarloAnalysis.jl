module Plotting

export generate_plot

using CarloAnalysis
using CairoMakie

function generate_plot(fig::Figure, results::JobResult, x, y;
                       xlabel, ylabel, title, line=true)
    ax = Axis(fig; title, xlabel, ylabel)

    data = results.data
    vals = getfield.(data[:, y], :val)
    errs = getfield.(data[:, y], :err)
    scatter!(data[:, x], vals)
    if line
        lines!(data[:, x], vals)
    end
    errorbars!(data[:, x], vals, errs)

    return ax
end

end