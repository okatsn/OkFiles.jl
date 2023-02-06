"""
`folderlistall(dir)` return the list of folders and all subfolders under `dir`. For its keyword arguments, see `walkdir`.
"""
function folderlistall(dir)
    wd = walkdir(dir)
    allpaths = String[]
    for (root, dirs, files) in wd
        for dir_i in dirs
            path_i = joinpath(root, dir_i)
            push!(allpaths, path_i)
        end
    end
    return allpaths
end

"""
`folderlistall()` returns results in the current directory (`pwd`)
"""
function folderlistall()
    folderlistall(pwd())
end

"""
`folderlist(dir; join=true)` return the list of folder but no subfolder under `dir`. This function uses `walkdir`.
"""
function folderlist(dir; join=true)
    wd = walkdir(dir) # you cannot add topdown=false to walkdir; otherwise, popfirst! won't return the first level of target folders/files.
    allpaths = String[]
    (root, dir, file) = popfirst!(wd)
    ans = if join
        joinpath.(root, dir)
    else
        dir
    end
    return ans
end

"""
`folderlist(;kwargs...)` returns results in the current directory (`pwd`)
"""
function folderlist(;kwargs...)
    folderlist(pwd();kwargs...)
end

"""
`folderlist(expr::Regex, dir; join=true)` returns a vector of paths who match `expr`.
"""
function folderlist(expr::Regex, dir; join=true)
    allfolders = folderlist(dir; join = join)
    if join
        desired_ind = occursin.(expr, basename.(allfolders))
    else
        desired_ind = occursin.(expr, allfolders)
    end
    return allfolders[desired_ind]
end
