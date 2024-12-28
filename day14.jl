input = split("""p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3""", '\n', keepempty=false)
input = readlines("input14")
#input = split(read("input", String), "\n\n")

function part1(input)
  function constrain(x, n)
    x >= n && return x % n
    x < 0 && return n + (x % n)
    return x
  end

  #m = 11
  #n = 7
  m = 101
  n = 103
  robots = Matrix{Int}(undef, length(input), 4)
  for (i, l) in pairs(input)
    robots[i, :] = parse.(Int, match(r"p=(.+),(.+) v=(.+),(.+)", l).captures)
  end

  for _ in 1:100
    robots[:, 1] = constrain.(robots[:, 1] .+ robots[:, 3], m)
    robots[:, 2] = constrain.(robots[:, 2] .+ robots[:, 4], n)
  end

  quadrants = zeros(Int, 2, 2)
  for i in axes(robots, 1)
    if robots[i, 1] == m ÷ 2 || robots[i, 2] == n ÷ 2
      continue
    end
    quadrants[(robots[i, 2]>n÷2)+1, (robots[i, 1]>m÷2)+1] += 1
  end

  return reduce(*, quadrants)
end

function part2(input)
  function constrain(x, n)
    x >= n && return x % n
    x < 0 && return n + (x % n)
    return x
  end

  function displayrobots(robots, m, n)
    grid = zeros(Int, n, m)
    for i in axes(robots, 1)
      grid[(robots[i, 2:-1:1] .+ 1)...] += 1
    end
    for i in axes(grid, 1)
      [print(j) for j in grid[i, :]]
      println()
    end
  end

  m = 101
  n = 103
  #m = 11
  #n = 7
  robots = Matrix{Int}(undef, length(input), 4)
  for (i, l) in pairs(input)
    robots[i, :] = parse.(Int, match(r"p=(.+),(.+) v=(.+),(.+)", l).captures)
  end

  for s in 1:10000
    robots[:, 1] = constrain.(robots[:, 1] .+ robots[:, 3], m)
    robots[:, 2] = constrain.(robots[:, 2] .+ robots[:, 4], n)

    grid = zeros(Int, n, m)
    for i in axes(robots, 1)
      grid[(robots[i, 2:-1:1] .+ 1)...] += 1
    end

    if all(grid .< 2)
      displayrobots(robots, m, n)
      println(s, " seconds")
      return
    end
  end
end

part2(input)