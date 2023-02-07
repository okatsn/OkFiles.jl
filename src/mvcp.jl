
"""
`mv2dir(item, newdir::AbstractString)` moves `item` to the `newdir` directory, preseving its original name.
"""
function mv2dir(item, newdir::AbstractString)
    newpath = joinpath(newdir, basename(item))
    mv(item, newpath)
    return newpath
end
