@testset "mv2cp.jl" begin
    using RDatasets,CSV
    iris = RDatasets.dataset("datasets", "iris")

    targetdir = joinpath("data")

    mkpath.(targetdir)
    srcfile = "iris.csv"

    try
        CSV.write(srcfile, iris)
    catch e
        @warn "Please clean the test folder before test."
        rethrow(e)
    end
    targetfile = mv2dir(srcfile, targetdir)

    @test !isfile(srcfile)
    @test isfile(targetfile)
    @test basename(targetfile) == basename(srcfile)

    @test isequal(CSV.read(targetfile,DataFrame), iris)
    rm(targetfile)
    @test !isfile(targetfile) || "File for test not removed correctly"
end
