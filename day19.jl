example = split("""r, wr, b, g, bwu, rb, gb, br

brwrr
bggr
gbbr
rrbgbr
ubwu
bwurrg
brgr
bbrgwb""", '\n')
input = readlines("input19")
#input = split(read("input", String), "\n\n")

function part1(input)
  function testdesign(design, patterns)
    design ∈ patterns && return true

    for p in patterns
      length(p) > length(design) && continue
      design[1:length(p)] == p || continue
      testdesign(design[length(p)+1:end], patterns) && return true
    end

    return false
  end

  patterns = split(input[1], ", ")
  designs = input[3:end]
  result = map(d -> testdesign(d, patterns), designs)
  return count(result)
end

function part2(input)
  function narrangements(design, patterns; cache=Dict())
    if design ∈ keys(cache)
      return cache[design]
    end

    narr = 0
    for p in patterns
      if p == design
        narr += 1
        continue
      end

      if length(p) >= length(design)
        continue
      end

      if design[1:length(p)] == p
        narr += narrangements(design[length(p)+1:end], patterns; cache)
      end
    end

    cache[design] = narr
    return narr
  end

  patterns = split(input[1], ", ")
  designs = input[3:end]
  result = map(d -> narrangements(d, patterns), designs)
  return sum(result)
end

println(part2(input))