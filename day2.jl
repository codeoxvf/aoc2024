lines = readlines("input2")

function part1(lines)
  safe = 0
  lines = split.(lines)
  lines = map(l -> parse.(Int, l), lines)
  filter!(l -> sort(l) == l || sort(l; rev=true) == l, lines)
  for l in lines
    adj = map((a, b) -> 1 <= abs(a-b) <= 3, l, l[2:end])
    if count(!, adj) == 0
      safe += 1
    end
  end
  return safe
end

function part2(lines)
  function is_safe(r)
    if sort(r) != r && sort(r; rev=true) != r
      return false
    end

    return count(!, map(
      (a, b) -> 1 <= abs(a-b) <= 3,
      r, r[2:end])) == 0
  end

  lines = split.(lines)
  lines = map(l -> parse.(Int, l), lines)

  safe = 0
  for l in lines
    if is_safe(l)
      safe += 1
      continue
    end

    for k in 1:size(l, 1)
      if is_safe(l[1:end .!= k])
        safe += 1
        break
      end
    end
  end
  return safe
end

println(part2(lines))