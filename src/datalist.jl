"""
# Example:
     find_in = "D:\\GoogleDrive\\1Programming\\DATA"
     regexppattern = r".*\\.mat"
     find = "both"
     method = "readdir"
     O = datalist(regexppattern, find_in, method, find);
# Output:
     O.fullpath is a string vector of the paths of the desired files or folders.
"""
function datalist(regexppattern::Regex, find_in::String;
                  method::String="readdir", find::String="both")
# CHECKPOINT:
# for the setting:
#     find_in = "D:\\GoogleDrive\\1Programming\\DATA"
#     find = "both"
#     method = "walkdir"
# The following results are verified as identical in their number:
#     datalist(r".*\.mat", find_in, method, find); # julia
#     datalist('*.mat',find_in,'Search','**'); % in matlab
#
#     datalist(r"\[.*\].*\.mat", find_in, method, find);
#     datalist('*[*]*.mat',find_in,'Search','**')

# code start here
    findfolders = true;
    findfiles = true;
    if find == "folder"
        findfiles = false;
    elseif find == "file"
        findfolders = false;
    end

    if method == "readdir";
        result_paths = readdir(find_in;join=true);
    elseif method == "walkdir"
        result_iterator = walkdir(find_in);
        result_paths = Vector{String}(); # or String[]
        for (root, dirs, files) in result_iterator
            # println("Directories in $root")
            in_folder_i = Vector{String}();
            if findfolders
                for dir in dirs
                    # path to directories
                    in_folder_i = vcat(in_folder_i,joinpath(root, dir));
                    # result_paths = push!(result_paths, joinpath(root, dir));
                end
            end
            if findfiles
                # println("Files in $root")
                for file in files
                    in_folder_i = vcat(in_folder_i,joinpath(root, file));
                    # println(joinpath(root, file)) # path to files
                end

            end
            result_paths = vcat(result_paths,in_folder_i);
        end
    end
    # check if the file/folder names match the regular expression pattern, and
    # return a 1-d true false array.
    desired_ind = occursin.(regexppattern,basename.(result_paths));

    flist = result_paths[desired_ind]
    if findfiles
        flist = flist[isfile.(flist)]
    end

    if findfolders
        flist = flist[isdir.(flist)]
    end

    O = (fullpath = sort(flist),);
    return O
end

# test:
# find_in = "D:\\GoogleDrive\\1Programming\\DATA"
# regexppattern = r"\[.*\].*\.mat"
# find = "both"
# method = "walkdir"
# O = datalist(regexppattern, find_in, method, find).fullpath;
# lenpaths = length(O)
#
# for i = 1:lenpaths
#     println(O[i]);
# end

