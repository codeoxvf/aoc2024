input = split("""###############
#.......#....E#
#.#.###.#.###.#
#.....#.#...#.#
#.###.#####.#.#
#.#.#.......#.#
#.#.#####.###.#
#...........#.#
###.#.#####.#.#
#...#.....#.#.#
#.#.#.###.#.#.#
#.....#...#.#.#
#.###.#.#.#.#.#
#S..#.....#...#
###############""", '\n')
#input = readlines("input16")
#input = split(read("input", String), "\n\n")

function showgrid(grid)
  for i in axes(grid, 1)
    [print(lpad(j, 5), ' ') for j in grid[i, :]]
    println()
  end
end

function part1(input)
  function search(grid, start, finish)
    dists = fill(-1, size(input))
    dists[start...] = 0
    queue = [(start, (0, 1))]
    while !isempty(queue)
      pos, dir = popfirst!(queue)
      if pos == finish
        continue
      end

      adj = getadj(pos, grid)
      for (a, adir) in adj
        if a == (8, 6)
          showgrid(dists)
          println(dir)
          println(adir)
        end
        adist = dists[pos...] + 1
        if adir != dir
          adist += 1000
        end
        if dists[a...] == -1 || adist < dists[a...]
          dists[a...] = adist
          deleteat!(findfirst(x -> x[1] == a, queue), queue)
          push!(queue, (a, adir))
        end
      end
    end

    return dists
  end

  getadj(pos, grid) =
    filter(!isnothing, map([(-1, 0), (1, 0), (0, -1), (0, 1)]) do d
      adj = pos .+ d
      if checkbounds(Bool, grid, adj...) &&
         grid[adj...] != '#'
        return adj, d
      end
    end)

  input = permutedims(reduce(hcat, collect.(input)))
  dists = search(input,
    Tuple(findfirst(x -> x == 'S', input)),
    Tuple(findfirst(x -> x == 'E', input)))
  return showgrid(dists)
end

println(part1(input))