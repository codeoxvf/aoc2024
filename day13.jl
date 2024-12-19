input = split("""Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400

Button A: X+26, Y+66
Button B: X+67, Y+21
Prize: X=12748, Y=12176

Button A: X+17, Y+86
Button B: X+84, Y+37
Prize: X=7870, Y=6450

Button A: X+69, Y+23
Button B: X+27, Y+71
Prize: X=18641, Y=10279""", "\n\n")
input = split(read("input13", String), "\n\n")

function part1(input)
  return reduce(+, map(input) do x
    matches = eachmatch(r".+: X[=+](.+), Y[=+](.+)", x)
    values = [parse.(Int, m.captures) for m in matches]
    presses = inv(hcat(values[1:2]...)) * values[3]
    ipresses = round.(Int, presses)
    if max(100, presses...) == 100 &&
       ipresses ≈ presses
      return 3ipresses[1] + ipresses[2]
    end
    return 0
  end)
end

function part2(input)
  return reduce(+, map(input) do x
    matches = eachmatch(r".+: X[=+](.+), Y[=+](.+)", x)
    values = [parse.(BigInt, m.captures) for m in matches]
    presses = inv(hcat(values[1:2]...)) * (values[3] .+ 10000000000000)
    ipresses = round.(BigInt, presses)
    if ipresses ≈ presses
      return 3ipresses[1] + ipresses[2]
    end
    return 0
  end)
end

println(part2(input))