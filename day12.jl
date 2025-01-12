example1 = split("""AAAA
BBCD
BBCC
EEEC""", '\n', keepempty=false)
example2 = split("""EEEEE
EXXXX
EEEEE
EXXXX
EEEEE""", "\n")
example3 = split("""AAAAAA
AAABBA
AAABBA
ABBAAA
ABBAAA
AAAAAA""", "\n")
example4 = split("""RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE""", "\n")
input = readlines("input12")

function part1(input)
  function perimeter!(grid, pos, checked)
    checked[pos...] = true
    local total = 0
    foreach([(-1, 0), (1, 0), (0, -1), (0, 1)]) do d
      next = d .+ pos
      if !checkbounds(Bool, grid, next...)
        total += 1
      elseif grid[next...] != grid[pos...]
        total += 1
      else
        checked[next...] && return
        total += perimeter!(grid, next, checked)
      end
    end
    return total
  end

  input = permutedims(reduce(hcat, collect.(input)))
  checked = zeros(Bool, size(input))
  total = 0
  for i in eachindex(IndexCartesian(), input)
    checked[i] && continue
    c = count(checked)
    p = perimeter!(input, Tuple(i), checked)
    total += (count(checked) - c)p
  end
  return total
end

function part2(input)
  function getcornermap(grid)
    cornermap = zeros(Int, size(grid))
    for pos in Tuple.(eachindex(IndexCartesian(), grid))
      cornermap[pos...] += ncorners(grid, pos)
    end
    return cornermap
  end

  ncorners(grid, pos) =
    sum([(-1, -1), (1, -1), (-1, 1), (1, 1)]) do d
      adj = [(pos[1] + d[1], pos[2]), (pos[1], pos[2] + d[2])]
      inbounds = map(x -> checkbounds(Bool, grid, x...), adj)
      iszero(inbounds) && return 1
      if all(inbounds)
        adjvalues = map(x -> grid[x...], adj)
        all(adjvalues .== grid[pos...]) &&
          grid[pos .+ d...] != grid[pos...] &&
          return 1
        all(adjvalues .!= grid[pos...]) && return 1
      else
        return grid[pos...] != grid[adj[findfirst(inbounds)]...]
      end
    end

  function getregion!(grid, pos, visited)
    buffer = copy(visited)
    visited[pos...] = true

    adj = filter(getadjacent(grid, pos)) do a
      checkbounds(Bool, grid, a...) &&
        !visited[a...] &&
        grid[a...] == grid[pos...]
    end
    foreach(adj) do neighbour
      visited .|= getregion!(grid, neighbour, visited)
    end
    return visited .⊻ buffer
  end

  getadjacent(grid, pos) =
    filter(p -> checkbounds(Bool, grid, p...),
      map(d -> pos .+ d,
        [(-1, 0), (1, 0), (0, -1), (0, 1)]))

  grid = permutedims(reduce(hcat, collect.(input)))
  visited = zeros(Bool, size(grid))
  cornermap = getcornermap(grid)
  totalprice = 0
  while !all(visited)
    region = getregion!(grid,
      Tuple(findfirst(.!visited)),
      visited)
    area = count(region)
    ncorners = sum(cornermap .* region)
    totalprice += area * ncorners
  end
  return totalprice
end

part2(input)