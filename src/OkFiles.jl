module OkFiles

# Write your package code here.
import SFTPClient: readdir
import SFTPClient
include("filelist.jl")
export filelist

include("filelistall.jl")
export filelistall


include("folderlist.jl")
export folderlist, folderlistall

include("datalist.jl")

include("mvcp.jl")
export mv2dir

using Printf
include("pathnorepeat.jl")
export pathnorepeat
end
