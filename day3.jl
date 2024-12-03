lines = ["xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"]
lines = ["xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"]
#lines = readlines("input3")

function part1(lines)
  sum = 0

  for m in eachmatch(r"mul\((\d+),(\d+)\)", join(lines))
    x = parse(Int, m.captures[1])
    y = parse(Int, m.captures[2])
    sum += x * y
  end

  return sum
end

function part2(lines)
  input = join(lines)
  sum = 0

  dont = findall("don't()", input)
  dontindex = [i[end] for i in dont]
  n = length(dontindex)
  doindex = Vector{Int}(undef, n)
  for i in 1:n
    doindex[i] = findnext("do()", input, dontindex[i])[end]
  end

  #=for m in eachmatch(r"mul\((\d+),(\d+)\)", join(lines))
    x = parse(Int, m.captures[1])
    y = parse(Int, m.captures[2])
    sum += x * y
  end

  return sum=#
end

println(part2(lines))