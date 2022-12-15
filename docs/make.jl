using OkFiles
using Documenter

DocMeta.setdocmeta!(OkFiles, :DocTestSetup, :(using OkFiles); recursive=true)

makedocs(;
    modules=[OkFiles],
    authors="okatsn <okatsn@gmail.com> and contributors",
    repo="https://github.com/okatsn/OkFiles.jl/blob/{commit}{path}#{line}",
    sitename="OkFiles.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://okatsn.github.io/OkFiles.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/okatsn/OkFiles.jl",
    devbranch="main",
)
