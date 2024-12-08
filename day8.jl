using Combinatorics

input = split("""............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............""", '\n', keepempty=false)
input = readlines("input8")

function part1(input)
  input = collect.(input)
  input = permutedims(reduce(hcat, input))
  antinodes = zeros(Bool, size(input))
  freqs = filter(i -> i != '.', unique(input))
  for f in freqs
    antennas = findall(i -> i == f, input)
    for a in antennas, b in antennas
      a == b && continue
      diff = 2a - b
      d = Tuple(diff)
      m, n = size(input)
      if 1 <= d[1] <= m && 1 <= d[2] <= n
        antinodes[diff] = true
      end
    end
  end
  return count(antinodes)
end

function part2(input)
  input = collect.(input)
  input = permutedims(reduce(hcat, input))
  antinodes = zeros(Bool, size(input))
  freqs = filter(i -> i != '.', unique(input))
  m, n = size(input)

  for f in freqs
    antennas = findall(i -> i == f, input)
    for (a, b) in combinations(antennas, 2)
      diff = a - b
      node = a
      while 1 <= Tuple(node)[1] <= m && 1 <= Tuple(node)[2] <= n
        antinodes[node] = true
        node += diff
      end

      node = a
      while 1 <= Tuple(node)[1] <= m && 1 <= Tuple(node)[2] <= n
        antinodes[node] = true
        node -= diff
      end
    end
  end
  return count(antinodes)
end

println(part2(input))