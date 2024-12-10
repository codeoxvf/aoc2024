input = split("""89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732""", '\n', keepempty=false)
input = readlines("input10")

function part1(input)
  function getneighbours(grid, pos, n)
    dirs = Set([(-1, 0), (1, 0), (0, -1), (0, 1)])
    neighbours = Set([pos .+ d for d in dirs])
    return filter(x -> checkbounds(Bool, grid, x...) && grid[x...] == n, neighbours)
  end

  function trailends(grid, pos, seq, known=Set())
    neighbours = getneighbours(grid, pos, seq[1])
    length(neighbours) == 0 && return []
    length(seq) == 1 && return known ∪ neighbours
    return ∪([trailends(grid, i, seq[2:end], known) for i in neighbours]...)
  end

  input = [parse.(Int, i) for i in collect.(input)]
  input = permutedims(reduce(hcat, input))

  total = 0
  for i in Tuple.(findall(x -> x == 0, input))
    total += length(trailends(input, i, collect(1:9)))
  end

  return total
end

function part2(input)
  function getneighbours(grid, pos, n)
    dirs = [(-1, 0), (1, 0), (0, -1), (0, 1)]
    neighbours = [pos .+ d for d in dirs]
    return filter(x -> checkbounds(Bool, grid, x...) && grid[x...] == n, neighbours)
  end

  function uniquetrails(grid, pos, seq)
    neighbours = getneighbours(grid, pos, seq[1])
    length(neighbours) == 0 && return 0
    length(seq) == 1 && return length(neighbours)
    return sum([uniquetrails(grid, i, seq[2:end]) for i in neighbours])
  end

  input = [parse.(Int, i) for i in collect.(input)]
  input = permutedims(reduce(hcat, input))

  total = 0
  for i in Tuple.(findall(x -> x == 0, input))
    total += uniquetrails(input, i, collect(1:9))
  end

  return total
end

println(part2(input))