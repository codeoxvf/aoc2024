using Combinatorics

input = split("""190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20""", '\n', keepempty=false)
input = readlines("input7")

function solution(input)
  function evaluate(target, current, seq)
    current > target && return false
    isempty(seq) && return target == current

    x = seq[1]
    return evaluate(target, current + x, seq[2:end]) ||
           evaluate(target, current * x, seq[2:end]) ||
           # part 2
           evaluate(target, parse(Int, string(current) * string(x)), seq[2:end])
  end

  input = [parse.(Int, i) for i in split.(input, r":? ")]
  total = 0
  for i in input
    if evaluate(i[1], i[2], i[3:end])
      total += i[1]
    end
  end
  return total
end

println(solution(input))