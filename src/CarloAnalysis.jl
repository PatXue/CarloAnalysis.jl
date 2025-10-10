module CarloAnalysis

export JobResults

include("JobResults.jl")
using .JobResults
include("Plotting.jl")
using .Plotting

end
