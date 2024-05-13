"""
`readdir` of  `FilePathsBase` and `SFTPClient` have different interface.
`okreaddir(dir; kwargs...) = readdir(dir; kwargs...)` is for the common interface of the `readdir` of `FilePathsBase`.
"""
okreaddir(dir; kwargs...) = readdir(dir; kwargs...)

"""
This function is intended that must follow `Base.readdir(sftp::SFTP, join::Bool = false, sort::Bool = true)` of the `SFTPClient` interface.
"""
okreaddir(dir::SFTPClient.SFTP; join = false, sort = true) = readdir(dir, join, sort)



"""
`filelist(dir; kwargs...)` return the list of files. For its keyword arguments, see `readdir`.
"""
function filelist(dir; readdirkwargs...)
    fs = okreaddir(dir; readdirkwargs...) # files and directories
    return fs[isfile.(fs)]
end


"""
`filelist(; kwargs...)` returns the paths for all the files in the current directory.
"""
function filelist(;opts...)
    filelist(pwd(); opts...)
end

"""
`filelist(expr::Regex, dir; kwargs...)` returns a vector of paths where the file matches `expr`.
"""
function filelist(expr::Regex, dir; opts...)
    fs = filelist(dir; opts...)
    target_id = occursin.(expr, basename.(fs))
    return fs[target_id]
end
