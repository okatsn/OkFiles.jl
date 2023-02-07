
function serial_number_4d(n)
    @sprintf "_%.4d" n
end

"""
`pathnorepeat(filepath; suffix_fun = serial_number_4d)` returns non-repeated file path, by increasing the `serial_number_4d` by default.
`suffix_fun` can be assigned as an arbitrary function that `suffix_fun(n)` returns a string updated by integer `n`.
"""
function pathnorepeat(filepath; suffix_fun = serial_number_4d)
    i = 1
    pathv0 = [splitext(filepath)...]
    while isfile(filepath) || isdir(filepath)
        pathv = copy(pathv0)
        insert!(pathv, 2, suffix_fun(i))
        i = i +1
        filepath = join(pathv, "")
    end
    return filepath
end
