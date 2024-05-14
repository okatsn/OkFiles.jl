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

"""
`filelistall(expr::Regex, sftp::SFTPClient.SFTP, vararg...)`

# Example

Return a list of all files start with string "2024" in the sftp and all its subdirectory, and
then download all files in this list:

```julia
using SFTPClient, OkFiles

sftp = SFTP("sftp://123.456.78.90", "myservername", "thisispassword")

download_list = filelistall(r"^2024.*", sftp)

mkpath.(joinpath.("data", "file2024", dirname.(download_list))) # directories of destination should be created otherwise `SFTPClient.download` will fail.

SFTPClient.download.(sftp, download_list, downloadDir="data/file2024")
```

!!! note
    `vararg` must follow the `SFTPClient` interface. For more information, please refer `OkFiles.sftpvararginterface`.

# Example
Search only files in the "em13" folder of the `sftp` server:
```julia
download_list = filelistall(r"^2024.*", sftp, "em13")
```
"""
function filelistall(expr::Regex, sftp::SFTPClient.SFTP, vararg...)
    allpaths = filelistall(sftp, vararg...)
    return selectpath(expr, allpaths)
end


function selectpath(expr, allpaths)
    desired_ind = occursin.(expr, basename.(allpaths))
    return allpaths[desired_ind]
end



"""
`filelistall(sftp::SFTPClient.SFTP)` return the list of paths to every file under the root.

`filelistall(sftp::SFTPClient.SFTP, dir)` return the list of paths to every file under the `dir`.
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
