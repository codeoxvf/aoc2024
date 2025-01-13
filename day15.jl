example = split("""##########
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
v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
""", "\n\n")
example2 = split("""#######
#...#.#
#.....#
#..OO@#
#..O..#
#.....#
#######

<vv<<^^<<^^""", "\n\n")
input = split(read("input15", String), "\n\n")

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
  function step!(grid, move)
    dirs = Dict(
      '^' => CartesianIndex(-1, 0),
      '>' => CartesianIndex(0, 1),
      'v' => CartesianIndex(1, 0),
      '<' => CartesianIndex(0, -1))
    robot = findfirst(x -> x == '@', grid)
    adj = robot + dirs[move]

    grid[adj] == '#' && return

    if grid[adj] == '.'
      grid[adj] = grid[robot]
      grid[robot] = '.'
      return
    end

    if move ∈ "<>"
      boxes = zeros(Bool, size(grid))
      boxes[robot] = true
      boxes[adj] = true
      check = adj + dirs[move]
      while grid[check] != '#'
        if grid[check] == '.'
          moveboxes!(grid, boxes, dirs[move])
          break
        end
        boxes[check] = true
        check += dirs[move]
      end
    else
      moveboxesvert!(grid, robot, dirs[move])
    end
  end

  function moveboxesvert!(grid, pos, dir)
    boxes = zeros(Bool, size(grid))
    boxes[pos] = true
    queue = [pos]
    while !isempty(queue)
      curr = popfirst!(queue)

      if grid[curr] ∈ "[]"
        otherhalf =
          curr + (grid[curr] == '[' ?
                  CartesianIndex(0, 1) : CartesianIndex(0, -1))
        if !boxes[otherhalf]
          boxes[otherhalf] = true
          push!(queue, otherhalf)
        end
      end

      adj = curr + dir
      grid[adj] == '#' && return
      if grid[adj] ∈ "[]"
        boxes[adj] = true
        push!(queue, adj)
      end
    end

    moveboxes!(grid, boxes, dir)
  end

  function moveboxes!(grid, boxes, dir)
    buffer = copy(grid)
    grid[boxes] .= '.'
    foreach(findall(identity, boxes)) do x
      grid[x+dir] = buffer[x]
    end
  end

  function displaygrid(grid)
    for l in axes(grid, 1)
      [print(i) for i in grid[l, :]]
      println()
    end
  end

  moves = replace(input[2], "\n" => "")
  lines = split(
    replace(input[1],
      '#' => "##", '.' => "..", 'O' => "[]", '@' => "@."),
    '\n')
  grid = permutedims(reduce(hcat, collect.(lines)))

  for move in moves
    step!(grid, move)
  end
  displaygrid(grid)

  return sum(findall(x -> x == '[', grid)) do pos
    y, x = Tuple(pos)
    100(y - 1) + x - 1
  end
end

part2(input)