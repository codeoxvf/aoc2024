input = split("""########
#..O.O.#
##@.O..#
#...O..#
#.#.O..#
#...O..#
#......#
########

<^^>>>vv<v>>v<<""", "\n\n", keepempty=true)
input = split("""##########
#..O..O.O#
#......O.#
#.OO..O.O#
#..O@..O.#
#O#..O...#
#O..O..O.#
#.OO.O.OO#
#....O...#
##########

<vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
<<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
>^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
<><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^""", "\n\n")
#input = readlines("input15")
#input = split(read("input15", String), "\n\n")

function part1(input)
  function checkstep!(grid, dir, x, y)
    dirs = Dict(
      '^' => (-1, 0),
      '>' => (0, 1),
      'v' => (1, 0),
      '<' => (0, -1))
    ny, nx = (y, x) .+ dirs[dir]
    if grid[ny, nx] == '#'
      return false
    elseif grid[ny, nx] == '.' || checkstep!(grid, dir, nx, ny)
      grid[ny, nx] = grid[y, x]
      grid[y, x] = '.'
      return true
    else
      return false
    end
  end

  function displaygrid(grid)
    for l in axes(grid, 1)
      [print(i) for i in grid[l, :]]
      println()
    end
  end

  dirs = replace(input[2], "\n" => "")
  input = split(input[1], '\n')
  input = permutedims(reduce(hcat, collect.(input)))

  for d in dirs
    y, x = Tuple(findfirst(x -> x == '@', input))
    checkstep!(input, d, x, y)
  end

  return sum(Tuple.(findall(x -> x == 'O', input))) do (y, x)
    return 100(y - 1) + x - 1
  end
end

function part2(input)
  function checkstep!(grid, dir, x, y)
    dirs = Dict(
      '^' => (-1, 0),
      '>' => (0, 1),
      'v' => (1, 0),
      '<' => (0, -1))
    ny, nx = (y, x) .+ dirs[dir]
    grid[ny, nx] == '#' && return false

    if dir == '>' || dir == '<'
      if grid[ny, nx] == '.' || check(grid, dir, nx, ny)
        grid[ny, nx] = grid[y, x]
        grid[y, x] = '.'
        return true
      end
      return false
    end

    # ^v
    grid[ny, nx] == '.' && return true
    # []
    side = Dict(']' => -1, '[' => 1)
    half = (ny, nx + side[grid[ny, nx]])
    if grid[(ny, nx) .+ dirs[dir]...] == '.' &&
       grid[half .+ dirs[dir]...] == '.'
      grid[(ny, nx) .+ dirs[dir]...] = grid[ny, nx]
      grid[half .+ dirs[dir]...] = grid[half...]
      return true
    end
    if check(grid, dir, nx, ny) && check(grid, dir, nx + side[grid[ny, nx]], ny)
      return true
    end
    return false
  end

  function movevert!(grid, dir, x, y)
    y, x = Tuple(findfirst(x -> x == '@', grid))
    check(grid, dir, x, y) || return
  end

  function displaygrid(grid)
    for l in axes(grid, 1)
      [print(i) for i in grid[l, :]]
      println()
    end
  end

  dirs = replace(input[2], "\n" => "")
  input = split(input[1], '\n')
  input = permutedims(reduce(hcat, collect.(input)))
  grid = similar(input, size(input, 1), 2size(input, 2))
  stretch = Dict(
    '#' => "##",
    '.' => "..",
    'O' => "[]",
    '@' => "@."
  )
  for (y, x) in Tuple.(keys(input))
    grid[y, 2x-1:2x] = collect(stretch[input[y, x]])
  end

  for d in dirs
    y, x = Tuple(findfirst(x -> x == '@', grid))
    checkstep!(grid, d, x, y)
  end
  displaygrid(grid)

  return sum(Tuple.(findall(x -> x == '[', grid))) do (y, x)
    return 100(y - 1) + x - 1
  end
end

println(part2(input))