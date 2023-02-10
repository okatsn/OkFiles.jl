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

    srcfile1 = "hello/world/iris2.csv"
    OkFiles.mkdirway.(srcfile1)
    try
        CSV.write(srcfile, iris)
        CSV.write(srcfile1, iris)
    catch e
        @warn "Please clean the test folder before test."
        rethrow(e)
    end

    ## Define target directory
    targetdir = joinpath("data", "foo", "bar")
    # targetdir NOT created first

    ## Test srcfile1
    targetfile = mv2dir(srcfile, targetdir, OkFiles.mkdirway)

    @test !isfile(srcfile)
    @test isfile(targetfile)
    @test basename(targetfile) == basename(srcfile)
    @test targetfile == joinpath(targetdir, srcfile)

    @test pathnorepeat(targetfile) == joinpath(targetdir, "iris$(OkFiles.serial_number_4d(1)).csv")

    @test isequal(CSV.read(targetfile,DataFrame), iris)

    ## Test srcfile2
    targetfile1 = mv2dir(srcfile1, targetdir, OkFiles.mkdirway)

    @test !isfile(srcfile1)
    @test isfile(targetfile1)
    @test basename(targetfile1) == basename(srcfile1)
    @test targetfile1 == joinpath(targetdir, basename(srcfile1))



    ## Remove file and folder
    rm("data"; recursive=true)
    rm("hello"; recursive=true)
    @test !isfile(targetfile) || "File for test not removed correctly"
    @test !isdir(joinpath("data","foo")) || "Folder for test does not removed correctly"



end




@testset "Test move folder to folder" begin
    using RDatasets,CSV
    iris = RDatasets.dataset("datasets", "iris")
    quakes = RDatasets.dataset("datasets", "quakes")

    ## Create source file
    srcfile1 = joinpath("hello", "world", "iris.csv")
    srcfile2 = joinpath("hello", "quakes.csv")
    srcdir = joinpath("hello")

    srcfiles = [srcfile1, srcfile2]
    OkFiles.mkdirway.(srcfiles)
    @test all(isdir.(dirname.(srcfiles)))

    try
        CSV.write(srcfile1, iris)
        CSV.write(srcfile2, quakes)
    catch e
        @warn "Please clean the test folder before test."
        rethrow(e)
    end

    ## Define target directory; targetdir NOT created first


    ## Test move a directory to another directory
    targetdir = mv2dir(srcdir, joinpath("another","world"), OkFiles.mkdirway)
    @test isdir(targetdir)
    @test !isfile(srcfile1)
    @test isfile(joinpath("another", "world","hello", "world", "iris.csv"))
    @test targetdir == joinpath("another", "world","hello")
    @test basename(targetdir) == basename(srcdir)
    # @test targetfile == joinpath(targetdir, basename(srcfile1))

    # @test pathnorepeat(targetfile) == joinpath(targetdir, "iris$(OkFiles.serial_number_4d(1)).csv")

    # @test isequal(CSV.read(targetfile,DataFrame), iris)

    # ## Remove file and folder
    # rm("data"; recursive=true)
    # @test !isfile(targetfile) || "File for test not removed correctly"
    # @test !isdir(joinpath("data","foo")) || "Folder for test does not removed correctly"

end
