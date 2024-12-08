input = split("""....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...""", '\n', keepempty=false)
input = readlines("input6")

function part1(input)
  function guardstep!(grid)
    dirs = Dict(
      '^' => (-1, 0),
      '>' => (0, 1),
      'v' => (1, 0),
      '<' => (0, -1))
    rotation = Dict(
      '^' => '>',
      '>' => 'v',
      'v' => '<',
      '<' => '^')

    n, m = size(grid)
    x, y = Tuple(findfirst(x -> x ∈ keys(dirs), grid))
    dir = dirs[grid[x, y]]

    if !(1 <= x + dir[1] <= n && 1 <= y + dir[2] <= m)
      grid[x, y] = 'X'
      return
    end

    if grid[x+dir[1], y+dir[2]] == '#'
      grid[x, y] = rotation[grid[x, y]]
    else
      grid[x+dir[1], y+dir[2]] = grid[x, y]
      grid[x, y] = 'X'
    end
  end

  input = permutedims(reduce(hcat, collect.(input)))

  while '^' ∈ input || '>' ∈ input || 'v' ∈ input || '<' ∈ input
    guardstep!(input)
  end

  return count(c -> c == 'X', input)
end

function part2(input)
  function guardlocation(grid)
    p = findfirst(x -> x ∈ ['^', '>', 'v', '<'], grid)
    isnothing(p) && return nothing
    return Tuple(p)
  end

  function issubarray(A, B)
    for i in eachindex(B)
      match = true
      for j in eachindex(A)
        if B[i+j-1] != A[j]
          match = false
          break
        end
      end
      match && return true
    end
    return false
  end

  function guardstep!(grid, path)
    dirs = Dict(
      '^' => (-1, 0),
      '>' => (0, 1),
      'v' => (1, 0),
      '<' => (0, -1))
    rotation = Dict(
      '^' => '>',
      '>' => 'v',
      'v' => '<',
      '<' => '^')

    n, m = size(grid)
    x, y = guardlocation(grid)
    dir = dirs[grid[x, y]]

    if !(1 <= x + dir[1] <= n && 1 <= y + dir[2] <= m)
      push!(path, (x, y))
      grid[x, y] = 'X'
      return
    end

    if grid[x+dir[1], y+dir[2]] ∈ ('#', 'O')
      grid[x, y] = rotation[grid[x, y]]
    else
      grid[x+dir[1], y+dir[2]] = grid[x, y]
      push!(path, (x, y))
      grid[x, y] = 'X'
    end
  end

  function checkloop(grid)
    path = []
    [guardstep!(grid, path) for _ in 1:3]
    while !isnothing(guardlocation(grid))
      issubarray(path[end-1:end], path[begin:end-2]) && return true
      guardstep!(grid, path)
    end
    return false
  end

  input = permutedims(reduce(hcat, collect.(input)))
  grid = copy(input)
  path = []
  solutions = []

  while !isnothing(guardlocation(grid))
    guardstep!(grid, path)
  end

  for p in path[begin:end]
    grid = copy(input)
    p == guardlocation(grid) && continue
    grid[p...] = '#'
    checkloop(grid) && push!(solutions, p)
  end

  return length(unique(solutions))
end

println(part2(input))