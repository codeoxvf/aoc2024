example = split("""
""", '\n')
input = readlines("input")
#input = split(read("input", String), "\n\n")

function part1(input)
  input = [parse.(Int, i) for i in collect.(input)]
  input = permutedims(reduce(hcat, input))
  return
end

println(part1(example))