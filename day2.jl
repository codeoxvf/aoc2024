input = readlines("input2")

function part1(input)
  safe = 0
  input = split.(input)
  input = map(l -> parse.(Int, l), input)
  filter!(l -> sort(l) == l || sort(l; rev=true) == l, input)
  for l in input
    adj = map((a, b) -> 1 <= abs(a - b) <= 3, l, l[2:end])
    if count(!, adj) == 0
      safe += 1
    end
  end
  return safe
end

function part2(input)
  function is_safe(r)
    if sort(r) != r && sort(r; rev=true) != r
      return false
    end

    return count(!, map(
      (a, b) -> 1 <= abs(a - b) <= 3,
      r, r[2:end])) == 0
  end

  input = split.(input)
  input = map(l -> parse.(Int, l), input)

  safe = 0
  for l in input
    if is_safe(l)
      safe += 1
      continue
    end

    for k in 1:size(l, 1)
      if is_safe(l[1:end.!=k])
        safe += 1
        break
      end
    end
  end
  return safe
end

println(part2(input))