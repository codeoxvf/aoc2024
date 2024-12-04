using LinearAlgebra

input = split("""MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX""", '\n', keepempty=false)
input = readlines("input4")

function part1(input)
  # What is going on with the function scope??
  # Does not validate input
  function searchloc(word::AbstractString, grid::Matrix, loc, dirs::Vector)
    t = 0
    l = length(word) - 1
    for d in dirs
      s = replace(d, 0 => 1)
      slice = grid[loc[1]:s[1]:loc[1]+d[1]*l, loc[2]:s[2]:loc[2]+d[2]*l]
      if (1 in size(slice) && join(slice) == word) ||
         join(diag(slice)) == word
        t += 1
      end
    end

    return t
  end

  function getdirs(i, l, n, m)
    dirs = vec(collect(Iterators.product(-1:1, -1:1)))

    if i[1] > n - l
      dirs = filter(d -> d[1] != 1, dirs)
    end
    if i[1] <= l
      dirs = filter(d -> d[1] != -1, dirs)
    end
    if i[2] > m - l
      dirs = filter(d -> d[2] != 1, dirs)
    end
    if i[2] <= l
      dirs = filter(d -> d[2] != -1, dirs)
    end

    return dirs
  end

  input = permutedims(reduce(hcat, collect.(input)))
  word = "XMAS"
  l = length(word) - 1
  n, m = size(input)
  total = 0
  result = zeros(Int, n, m)

  for i in CartesianIndices(input)
    dirs = getdirs(i, l, n, m)
    total += searchloc(word, input, i, dirs)
    result[i] = searchloc(word, input, i, dirs)
  end

  return total
end

function part2(input)
  input = permutedims(reduce(hcat, collect.(input)))
  total = 0
  for i in axes(input, 1)[begin+1:end-1], j in axes(input, 2)[begin+1:end-1]
    if input[i, j] != 'A'
      continue
    end
    dirs = [(-1, -1), (-1, 1), (1, -1), (1, 1)]
    locs = [input[i+d[1], j+d[2]] for d in dirs]
    if count(c -> c == 'S', locs) == count(c -> c == 'M', locs) == 2 &&
       locs[1] != locs[4]
      total += 1
    end
  end
  return total
end

println(part2(input))