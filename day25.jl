example = split("""#####
.####
.####
.####
.#.#.
.#...
.....

#####
##.##
.#.##
...##
...#.
...#.
.....

.....
#....
#....
#...#
#.#.#
#.###
#####

.....
.....
#.#..
###..
###.#
###.#
#####

.....
.....
.....
#....
#.#..
#.#.#
#####""", "\n\n")
#input = readlines("input")
input = split(read("input25", String), "\n\n")

function part1(input)
  locks = []
  keys = []
  for schem in map(
    x -> permutedims(reshape(collect(strip(x) * '\n'), 6, 7))[:, 1:5],
    input)
    if all(schem[1, :] .== '#')
      push!(locks, [findfirst(x -> x == '.', schem[:, i]) - 2 for i in 1:5])
    end
    if all(schem[7, :] .== '#')
      push!(keys, [6 - findlast(x -> x == '.', schem[:, i]) for i in 1:5])
    end
  end

  sum([all(l + k .<= 5) for l in locks, k in keys])
end

part1(input)