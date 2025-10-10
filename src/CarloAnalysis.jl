module CarloAnalysis

export JobResults

using Carlo.ResultTools
using DataFrames

struct JobResults
    jobpath::String     # Path to folder with all job outputs
    jobname::String     # Name of job in jobpath
    data::DataFrame     # Parsed data from jobname.results.json
end

function JobResults(jobpath::String, jobname::String)
    JobResults(
        jobpath, jobname,
        ResultTools.dataframe("$jobpath/$jobname.results.json")
    )
end

end
