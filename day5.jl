input = """47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47"""
input = read("input5", String)

function part1(input)
  input = split(input, "\n\n")
  rules = [parse.(Int, i) for i in split.(split(input[1]), '|')]
  updates = [parse.(Int, i) for i in split.(split(input[2]), ',')]
  total = 0

  for u in updates
    ordered = true
    for r in rules
      if r[1] in u && r[2] in u &&
         findfirst(x -> x == r[1], u) > findfirst(x -> x == r[2], u)
        ordered = false
      end
    end
    if ordered
      total += u[(length(u)+1)÷2]
    end
  end

  return total
end

function part2(input)
  function checkorder(rules, update)
    local ordered = true
    errors = []
    for r in rules
      index = (findfirst(x -> x == r[1], update),
        findfirst(x -> x == r[2], update))

      if r[1] in update && r[2] in update &&
         index[1] > index[2]
        ordered = false
        push!(errors, index)
      end
    end
    return ordered, errors
  end

  function fixorder(rules, update)
    _, errors = checkorder(rules, update)
    isempty(errors) && return update

    buf = update[errors[1][1]]
    update[errors[1][1]] = update[errors[1][2]]
    update[errors[1][2]] = buf

    update = fixorder(rules, update)
  end

  input = split(input, "\n\n")
  rules = [parse.(Int, i) for i in split.(split(input[1]), '|')]
  updates = [parse.(Int, i) for i in split.(split(input[2]), ',')]
  total = 0

  for u in updates
    ordered, _ = checkorder(rules, u)
    if !ordered
      u = fixorder(rules, u)
      total += u[(length(u)+1)÷2]
    end
  end

  return total
end

println(part2(input))