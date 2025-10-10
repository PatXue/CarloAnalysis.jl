module JobResults

export JobResult

using Carlo.ResultTools
using DataFrames

struct JobResult
    jobpath::String     # Path to folder with all job outputs
    jobname::String     # Name of job in jobpath
    data::DataFrame     # Parsed data from jobname.results.json
end

function JobResult(jobpath::String, jobname::String)
    JobResult(
        jobpath, jobname,
        DataFrame(ResultTools.dataframe("$jobpath/$jobname.results.json"))
    )
end

Base.getindex(result::JobResult, cols) = result.data[:, cols]

end