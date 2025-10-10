module JobResults

export JobResult

using Carlo.ResultTools
using DataFrames
using HDF5

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

function read_meas_file(filepath::String, ys...)
    samples = []
    h5open(filepath) do file
        observables = file["observables"]
        for y in ys
            push!(samples, read(observables, "$y/samples"))
        end
    end
    return DataFrame(ys .=> samples)
end

end