lines = ["xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"]
lines = ["xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"]
lines = readlines("input3")

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
  sum = 0
  enabled = true

  for m in eachmatch(r"(mul\((\d+),(\d+)\)|don't\(\)|do\(\))",
    join(lines))
    RegexMatch
    if enabled && startswith(m.match, "mul")
      x = parse(Int, m.captures[2])
      y = parse(Int, m.captures[3])
      sum += x * y
    elseif m.match == "don't()"
      enabled = false
    elseif m.match == "do()"
      enabled = true
    end
  end

  return sum
end

println(part2(lines))