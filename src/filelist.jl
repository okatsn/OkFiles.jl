"""
`filelist(dir; join=true, sort=true)` return the list of files. For its keyword arguments, see `readdir`.
"""
function filelist(dir; join=true, sort=true)
    fs = readdir(dir; join=true, sort=sort) # files and directories
    if join # == true
        return fs[isfile.(fs)]
    else
        return basename.(fs[isfile.(joinpath.(dir,fs))])
    end
    # KEYNOTE: Why not just pass kwargs to readdir (why we cannot have a `filelist(dir; kwargs...)`)?
    # The reason why this step is seemingly redundant is:
    # - The `readdir` in this function MUST called with `join=true`, for the later use of `isfile`.
end

"""
`filelist(dir::SFTPClient.SFTP [, subdir])` returns the file list for the SFTP directory.
This function utilize `Base.readdir(sftp::SFTP, join::Bool = false, sort::Bool = true)` of `SFTPClient`.

This function currently do no support `join` and `sort` argument, because
it rely on `sftpstat` to check whether a path is a file, but `sftpstat` always returns unsorted and
not-joined results.
"""
function filelist(sftp::SFTPClient.SFTP, vararg...)
    # The interface of `readdir` of  `FilePathsBase` is different from that of `SFTPClient`.
    # The output of `SFTPClient`'s `readdir` have a slightly different (`readdir(sftp::SFTP, join::Bool = false, sort::Bool = true)`)
    # interface (`join`, `sort` are positional arguments), and `isfile` do not work for its output.
    # For these reasons, this is why a specialized `filelist` is required for reading SFTP files.

    # fs = SFTPClient.readdir(sftp, join, sort)
    subdir = sftpvararginterface(vararg)
    stat = SFTPClient.sftpstat(sftp, subdir)
    everything = getproperty.(stat, :desc)
    whichisfile = stat .|> SFTPClient.isfile
    return everything[whichisfile]
end


"""
`filelist(; kwargs...)` returns the paths for all the files in the current directory.
`kwargs` those forwarded to the method of `filelist(dir; kwargs...)`.
"""
function filelist(;opts...)
    filelist(pwd(); opts...)
end

"""
`filelist(expr::Regex, dir; kwargs...)` returns a vector of paths where the file matches `expr`.
`kwargs` those forwarded to the method of `filelist(dir; kwargs...)`.
"""
function filelist(expr::Regex, dir; opts...)
    fs = filelist(dir; opts...)
    target_id = occursin.(expr, basename.(fs))
    return fs[target_id]
end
