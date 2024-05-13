"""
`filelist(dir; join=true, sort=true)` return the list of files. For its keyword arguments, see `readdir`.
"""
function filelist(dir; readdirkwargs...)
    fs = readdir(dir; readdirkwargs...) # files and directories
    return fs[isfile.(fs)]
end

"""
`filelist(; join=true, sort=true)` returns the paths for all the files in the current directory.
"""
function filelist(;opts...)
    filelist(pwd(); opts...)
end

"""
`filelist(expr::Regex, dir; join=true, sort=true)` returns a vector of paths where the file matches `expr`.
"""
function filelist(expr::Regex, dir; opts...)
    fs = filelist(dir; opts...)
    target_id = occursin.(expr, basename.(fs))
    return fs[target_id]
end
