module CarloAnalysis

export JobResult, generate_plot

include("JobResults.jl")
using .JobResults
include("Plotting.jl")
using .Plotting

end
