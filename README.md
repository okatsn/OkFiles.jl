# OkFiles

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://okatsn.github.io/OkFiles.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://okatsn.github.io/OkFiles.jl/dev/)
[![Build Status](https://github.com/okatsn/OkFiles.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/okatsn/OkFiles.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/okatsn/OkFiles.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/okatsn/OkFiles.jl)

[OkFiles.jl](https://okatsn.github.io/OkFiles.jl/) offers a collection of convenient tools for file searching, copying, and moving operations. This Julia package builds upon the functionality of Julia's Base functions.


| Features            |                                                                                 | Tools                                                     |
|---------------------|---------------------------------------------------------------------------------|-----------------------------------------------------------|
| File Search         | Search for files using regular expressions.                                     | `folderlist`, `folderlistall`, `filelist` , `filelistall` |
| File copying/moving | Move files efficiently from one location to another.                            | `mv2dir`                                                  |
| Path creating       | Create non-repeated file/path name and make directories on the way to the path. | `pathnorepeat`, `mkdirway`                                |

## License

OkFiles.jl is released under the MIT License.