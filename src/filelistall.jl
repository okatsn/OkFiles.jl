"""
Similar to `filelist`, `filelistall(dir)` returns all files in the directory (**as well as its subdirectory**) `dir`.
"""
function filelistall(dir)
    wd = walkdir(dir)
    allpaths = String[]
    iteratedirwalked!(wd, allpaths)
    return allpaths
end

"""
Similar to `filelist`, `filelistall(expr::Regex, dir)` returns files whose name matches `expr` in the directory (**as well as its subdirectory**) `dir`.
"""
function filelistall(expr::Regex, dir)
    allpaths = filelistall(dir)
    return selectpath(expr, allpaths)
end


function filelistall(expr::Regex, sftp::SFTPClient.SFTP, vararg...)
    allpaths = filelistall(sftp, vararg...)
    return selectpath(expr, allpaths)
end


function selectpath(expr, allpaths)
    desired_ind = occursin.(expr, basename.(allpaths))
    return allpaths[desired_ind]
end



"""

```julia
SFTPClient.download.(sftp, fpath, downloadDir="") # download the entire folder of root.
```

"""
function filelistall(sftp::SFTPClient.SFTP, vararg...)
    allpaths = String[]
    subdir = sftpvararginterface(vararg)
    wd = SFTPClient.walkdir(sftp, subdir)
    iteratedirwalked!(wd, allpaths)
    return allpaths
end


function iteratedirwalked!(wd, allpaths)
    for (root, dirs, files) in wd
        for file in files
            path_i = joinpath(root, file)
            push!(allpaths, path_i)
        end
    end
end
