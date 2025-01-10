example = split("""###############
#...#...#.....#
#.#.#.#.#.###.#
#S#...#.#.#...#
#######.#.#.###
#######.#.#...#
#######.#.###.#
###..E#...#...#
###.#######.###
#...###...#...#
#.#####.#.###.#
#.#...#.#.#...#
#.#.#.#.#.#.###
#...#...#...###
###############""", "\n")
input = readlines("input20")
#input = split(read("input", String), "\n\n")

function showgrid(grid; pad=2)
  for i in axes(grid, 1)
    [print(lpad(j, pad)) for j in grid[i, :]]
    println()
  end
end

function getdists(grid, start, finish)
  route = []
  dists = fill(-1, size(grid))
  dists[start...] = 0
  queue = [start]
  while !isempty(queue)
    pos = popfirst!(queue)
    push!(route, pos)
    if pos == finish
      continue
    end

    adj = getadj(pos, grid)
    for a in adj
      adist = dists[pos...] + 1

      if dists[a...] == -1 || dists[a...] > adist
        dists[a...] = adist
        push!(queue, a)
      end
    end
  end

  return dists, route
end

getadj(pos, grid) =
  filter(!isnothing, map([(-1, 0), (1, 0), (0, -1), (0, 1)]) do d
    adj = pos .+ d
    if checkbounds(Bool, grid, adj...) &&
       grid[adj...] != '#'
      return adj
    end
  end)

function part1(input)
  grid = permutedims(reduce(hcat, collect.(input)))
  finish = Tuple(findfirst(x -> x == 'E', grid))
  start = Tuple(findfirst(x -> x == 'S', grid))
  dists, route = getdists(grid, start, finish)

  cheatcount = 0
  for i in eachindex(route), j in eachindex(route)[i+1:end]
    sum(abs.(route[i] .- route[j])) > 2 && continue
    if dists[route[j]...] - dists[route[i]...] - 2 ≥ 100
      cheatcount += 1
    end
  end

  return cheatcount
end

function part2(input)
  grid = permutedims(reduce(hcat, collect.(input)))
  finish = Tuple(findfirst(x -> x == 'E', grid))
  start = Tuple(findfirst(x -> x == 'S', grid))
  dists, route = getdists(grid, start, finish)

  cheatcount = 0
  #cheats = Dict()
  for i in eachindex(route), j in eachindex(route)[i+1:end]
    cheatdist = sum(abs.(route[i] .- route[j]))
    cheatdist > 20 && continue
    cheatscore = dists[route[j]...] - dists[route[i]...] - cheatdist
    #=if cheatscore ≥ 50
      cheats[(route[i], route[j])] = cheatscore
    end=#
    if cheatscore ≥ 100
      cheatcount += 1
    end
  end

  #=cheatcounts = Dict()
  foreach(keys(cheats)) do x
    cheats[x] == 82 && println(x)
    if cheats[x] ∈ keys(cheatcounts)
      cheatcounts[cheats[x]] += 1
    else
      cheatcounts[cheats[x]] = 1
    end
  end
  for i in sort(collect(keys(cheatcounts)))
    println(cheatcounts[i], " ", i)
  end=#
  return cheatcount
end

part2(input)