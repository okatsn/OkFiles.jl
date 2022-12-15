using Test
# using TestItems
using OkFiles

function targetlist(targetexpr::Regex, dir2walk::AbstractString)
    # targetexpr = r"(\.jl)$";
    fulllist = String[]
    for (root, folders, files) in walkdir(dir2walk)
        for file in files
            push!(fulllist, joinpath(root, file))
        end
    end
    allfiles = basename.(fulllist)
    targetid = occursin.(targetexpr, allfiles)

    targetpaths = fulllist[targetid]
    return targetpaths, allfiles
end

(testfiles, allnames) = targetlist(r"^(?!runtests).*(\.jl)$", "./");
# pwd() here should be "./test/"
@testset "OkFiles.jl" begin
    for f in testfiles
        # write test in the file of the same name.
        # E.g., `test/mycode.jl` for testing `src/mycode.jl`.
        include(f)
    end
end

using Documenter
@testset "DocTests" begin
    DocMeta.setdocmeta!(OkFiles, :DocTestSetup, :(using OkFiles); recursive=true)
    # using the package everywhere in the doc
    # See also https://documenter.juliadocs.org/stable/man/doctests/#Setup-Code


    doctest(OkFiles; manual = false) # this makes jldoctest also be tested in a local test
end
# @testitem "test vscode testitem" begin
#     println("Only `@testitem` block will be detectable by vscode's test")
#     @test true
#     # See https://youtu.be/Okn_HKihWn8?t=1299
# end
