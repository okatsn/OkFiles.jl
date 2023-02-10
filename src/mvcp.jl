mkdirway_brief = "`mkdirway(newpath)` makes directories along the way to the file `newpath`"


"""
$mkdirway_brief.
If `newpath` is a directory, directories will be made up to its parent (i.e., `dirname(newpath)`).
This behavior is intended for `mv(dir0, dir1)` with out `force=true`, that `dir1` should not be created first.

`mkdirway(newpath)` just returns `newpath` without any modification on it.
"""
function mkdirway(newpath)
    newdir = dirname(newpath)
    mkpath(newdir)
    return newpath
end



"""
`mv2dir(srcfile, newdir::AbstractString, f::Function)` moves a file `srcfile` to a directory `newdir`. The new path for the `srcfile` is `newpath = joinpath(newdir, basename(srcfile)) |> f`, where an arbitrary function `f` can be applied to the `newpath`.

`mv2dir` takes keyword arguments of `mv`.

# Examples
$mkdirway_brief:
```julia
mv2dir("hello/world/iris.csv", "another/world", mkdirway) # results in "another/world/iris.csv"
```
which is equivualent to:
```julia
mkpath("another/world")
mv2dir("hello/world/iris.csv", "another/world") # results in "another/world/iris.csv"
```


If `srcfile` is a directory,
```julia
mkpath("another") # noted that "another/world" not created
mv2dir("hello/world", "another") # Move all contents under "world" to the new folder "another", resulting in "another/world/iris.csv"
```
which is equivualent to
```julia
mv2dir("hello/world", "another", mkdirway) # results in "another/world/iris.csv"
```

Also see the docstring of `mkdirway`.

# Another example

You can apply `f = pathnorepeat` that
```julia
mv2dir("hello/world", "another", pathnorepeat) # results in "another/world_0001/iris.csv" if directory "another/world" already exists.

mv2dir("hello/world/iris.csv", "another/world", pathnorepeat) # results in "another/world/iris_0001.csv" if file "another/world/iris.csv" already exists.
```

"""
function mv2dir(srcfile, newdir::AbstractString, f::Function; kwargs...)
    # if srcfile is a directory, newpath is the new directory for srcdir
    newpath = joinpath(newdir, basename(srcfile)) |> f
    mv(srcfile, newpath; kwargs...)
    return newpath
end

"""
`mv2dir(srcfile, newdir::AbstractString)` moves `srcfile` to the `newdir` directory, preseving its original name (`f = identity`).
"""
mv2dir(srcfile, newdir; kwargs...) = mv2dir(srcfile, newdir, identity; kwargs...)
