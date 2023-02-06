
@testset "filelist.jl" begin
    dir = pwd()
    opts = (join = true, )
    fs = readdir(dir; opts...)
    @test filelist(dir; opts...) == fs[isfile.(fs)]
    @test isequal(filelist(dir; join=false), basename.(filelist(dir; join=true)))
    @test isequal(filelist(dir; sort=true), sort(filelist(dir; sort=false)))

    @test isequal(filelist(dir), OkFiles.datalist(r".*",dir;find="file").fullpath)
end
