module JobResults

export JobResult, GroupedJobResult, get_mctime_data

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

struct GroupedJobResult
    jobpath::String             # Path to folder with all job outputs
    jobname::String             # Name of job in jobpath
    data::GroupedDataFrame      # Parsed data from jobname.results.json
end

function GroupedJobResult(jobpath::String, jobname::String, cols)
    data = DataFrame(ResultTools.dataframe("$jobpath/$jobname.results.json"))
    GroupedJobResult(
        jobpath, jobname,
        groupby(data, cols)
    )
end

Base.getindex(result::JobResult, col) = result.data[:, col]
Base.getindex(result::JobResult, cols::Vector) = result.data[:, cols]

function read_meas_file(filepath::String, ys...)
    samples = []
    h5open(filepath) do file
        observables = file["observables"]
        for y in ys
            raw_sample = read(observables, "$y/samples")
            sample = collect(eachslice(raw_sample, dims=length(size(raw_sample))))
            push!(samples, sample)
        end
    end
    return DataFrame(ys .=> samples)
end

function get_mctime_data(result::JobResult, ys...)
    jobdir = "$(result.jobpath)/$(result.jobname).data"
    taskdirs = readdir(jobdir, join=true) .* "/run0001.meas.h5"
    return read_meas_file.(taskdirs, ys...)
end

end