input = split("""AAAA
BBCD
BBCC
EEEC""", '\n', keepempty=false)
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
  function sides!(grid, pos, checked)
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
        total += sides!(grid, next, checked)
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
    p = sides!(input, Tuple(i), checked)
    total += (count(checked) - c)p
  end
  return total
end

println(part2(input))