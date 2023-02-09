@testset "mv2cp.jl and pathnorepeat.jl" begin
    using RDatasets,CSV
    iris = RDatasets.dataset("datasets", "iris")

    ## Create source file
    srcfile = "iris.csv"
    try
        CSV.write(srcfile, iris)
    catch e
        @warn "Please clean the test folder before test."
        rethrow(e)
    end

    ## Define target directory
    targetdir = joinpath("data")
    # targetdir created first
    mkpath(targetdir)


    targetfile = mv2dir(srcfile, targetdir)

    @test !isfile(srcfile)
    @test isfile(targetfile)
    @test basename(targetfile) == basename(srcfile)
    @test targetfile == joinpath(targetdir, srcfile)

    @test pathnorepeat(targetfile) == joinpath(targetdir, "iris$(OkFiles.serial_number_4d(1)).csv")

    @test isequal(CSV.read(targetfile,DataFrame), iris)

    ## Remove file
    rm(targetfile)
    @test !isfile(targetfile) || "File for test not removed correctly"



end



@testset "mv2dir with mkpath" begin
    using RDatasets,CSV
    iris = RDatasets.dataset("datasets", "iris")

    ## Create source file
    srcfile = "iris.csv"

    try
        CSV.write(srcfile, iris)
    catch e
        @warn "Please clean the test folder before test."
        rethrow(e)
    end

    ## Define target directory
    targetdir = joinpath("data", "foo", "bar")
    # targetdir NOT created first

    targetfile = mv2dir(srcfile, targetdir; mkpath=true)

    @test !isfile(srcfile)
    @test isfile(targetfile)
    @test basename(targetfile) == basename(srcfile)
    @test targetfile == joinpath(targetdir, srcfile)

    @test pathnorepeat(targetfile) == joinpath(targetdir, "iris$(OkFiles.serial_number_4d(1)).csv")

    @test isequal(CSV.read(targetfile,DataFrame), iris)

    ## Remove file and folder
    rm("data"; recursive=true)
    @test !isfile(targetfile) || "File for test not removed correctly"
    @test !isdir(joinpath("data","foo")) || "Folder for test does not removed correctly"



end
