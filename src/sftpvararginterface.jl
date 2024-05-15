
"""
`sftpvararginterface(vararg)` returns the second argument for `SFTPClient.walkdir` and `SFTPClient.sftpstat`, based on variant input argument `vararg` of length 0 (empty) or 1.
"""
function sftpvararginterface(vararg)
    if !isempty(vararg)
        subdir = only(vararg)
    else
        subdir = "."
    end
    return subdir
end
