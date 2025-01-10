example = split("""1
2
3
2024""", '\n')
input = readlines("input22")
#input = split(read("input", String), "\n\n")

function part1(input)
  mix(secret, n) = secret ⊻ n
  prune(secret) = secret % 16777216
  step(secret) =
    mix(secret, 64secret) |> prune |>
    (x -> mix(x, x÷32)) |> prune |>
    (x -> mix(x, 2048x)) |> prune

  input = parse.(Int, input)
  for _ in 1:2000
    input = map(step, input)
  end
  return sum(input)
end

function part2(input)
  mix(secret, n) = secret ⊻ n
  prune(secret) = secret % 16777216
  step(secret) =
    mix(secret, 64secret) |> prune |>
    (x -> mix(x, x÷32)) |> prune |>
    (x -> mix(x, 2048x)) |> prune

  input = parse.(Int, input)
  input = [123]
  prices = zeros(Int, length(input), 2001)
  prices = zeros(Int, length(input), 10)
  prices[:, 1] = input .% 10
  #for i in 1:2000
  for i in 1:9
    input = map(step, input)
    prices[:, i+1] = input .% 10
  end

  @views changes = prices[:, begin+1:end] - prices[:, begin:end-1]
  changes = hcat(repeat([nothing], length(input)), changes)

  foreach(Tuple.(argmax(prices[:, begin+4:end], dims=2))) do (_, loc)
    loc+=4
    println(prices[:, loc])
    println(changes[:, loc-3:loc])
  end
end

println(part2(example))