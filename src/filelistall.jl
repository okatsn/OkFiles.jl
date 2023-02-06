"""
Similar to `filelist`, `filelistall(dir)` returns all files in the directory (**as well as its subdirectory**) `dir`.
"""
function filelistall(dir)
    wd = walkdir(dir)
    allpaths = String[]
    for (root, dirs, files) in wd
        for file in files
            path_i = joinpath(root, file)
            push!(allpaths, path_i)
        end
    end
    return allpaths
end 

"""
Similar to `filelist`, `filelistall(expr::Regex, dir)` returns files whose name matches `expr` in the directory (**as well as its subdirectory**) `dir`.
"""
function filelistall(expr::Regex, dir)
    allpaths = filelistall(dir)
    desired_ind = occursin.(expr, basename.(allpaths))
    return allpaths[desired_ind]
end