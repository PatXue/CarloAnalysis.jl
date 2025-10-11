module CarloAnalysis

export JobResult, generate_plot!, get_mctime_data

include("JobResults.jl")
using .JobResults
include("Plotting.jl")
using .Plotting

end
