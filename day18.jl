example = split("""5,4
4,2
4,5
3,0
2,1
6,3
2,4
1,5
0,6
3,3
2,6
5,1
1,2
5,5
2,5
6,5
1,4
0,4
6,4
1,1
6,1
1,0
0,5
1,6
2,0""", "\n")
input = readlines("input18")
#input = split(read("input", String), "\n\n")

function showgrid(grid; pad=2)
  for i in axes(grid, 1)
    [print(lpad(j, pad), ' ') for j in grid[i, :]]
    println()
  end
end

function search(space, start, finish)
  dists = fill(-1, size(space))
  dists[start...] = 0
  queue = [start]

  while !isempty(queue)
    pos = popfirst!(queue)
    if pos == finish
      continue
    end

    adj = getadj(pos, space)
    for a in adj
      if dists[a...] == -1 || dists[pos...] + 1 < dists[a...]
        dists[a...] = dists[pos...] + 1
        push!(queue, a)
      end
    end
  end

  return dists
end

getadj(pos, space) =
  filter(!isnothing, map([(-1, 0), (1, 0), (0, -1), (0, 1)]) do d
    adj = pos .+ d
    if checkbounds(Bool, space, adj...) &&
       !space[adj...]
      return adj
    end
  end)

function part1(input)
  #l = 6
  #n = 12
  n = 70
  bytes = [parse.(Int, match(r"(\d+),(\d+)", l).captures) for l in input]
  space = zeros(Bool, n + 1, n + 1)
  for pos in bytes[1:1024]
    space[pos .+ 1...] = true
  end
  space = permutedims(space) # row major

  #showgrid(convert(Matrix{Int}, space), pad=1)
  dists = search(space, size(space), (1, 1))
  #showgrid(dists)
  return dists[1, 1]
end

function part2(input)
  bytes = [parse.(Int, match(r"(\d+),(\d+)", l).captures) for l in input]
  n = 70
  space = zeros(Bool, n + 1, n + 1)

  i = 1
  while search(permutedims(space), size(space), (1, 1))[1, 1] != -1
    space[bytes[i] .+ 1...] = true
    i += 1
  end
  return bytes[i-1]
end

part2(input)