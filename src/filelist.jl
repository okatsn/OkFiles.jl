"""
`filelist(dir; kwargs...)` return the list of files. For its keyword arguments, see `readdir`.
"""
function filelist(dir; readdirkwargs...)
    fs = readdir(dir; readdirkwargs...) # files and directories
    return fs[isfile.(fs)]
end

"""
`filelist(dir::SFTPClient.SFTP; join = false, sort = true)` returns the file list for the SFTP directory.
This function utilize `Base.readdir(sftp::SFTP, join::Bool = false, sort::Bool = true)` of `SFTPClient`.
"""
function filelist(dir::SFTPClient.SFTP; join = false, sort = true)
    # KEYNOTE: Must Keep the interface consistent with that of
    # `Base.readdir(sftp::SFTP, join::Bool = false, sort::Bool = true)` (using SFTPClient)
    fs = readdir(dir, join, sort) # `readdir` of  `FilePathsBase` and `SFTPClient` have different interface, and this is why I define two `filelist`
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
