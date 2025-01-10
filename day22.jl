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
    (x -> mix(x, x ÷ 32)) |> prune |>
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
    (x -> mix(x, x ÷ 32)) |> prune |>
    (x -> mix(x, 2048x)) |> prune

  n = 2000
  input = parse.(Int, input)
  prices = zeros(Int, length(input), n + 1)
  prices[:, 1] = input .% 10
  for i in 1:n
    input = map(step, input)
    prices[:, i+1] = input .% 10
  end

  @views changes = prices[:, begin+1:end] - prices[:, begin:end-1]
  changes = hcat(repeat([nothing], length(input)), changes)

  cache = Dict()
  for i in axes(changes, 1), j in axes(changes, 2)[begin+4:end]
    seq = changes[i, j-3:j]
    if seq ∉ keys(cache)
      cache[seq] = fill(-1, size(changes, 1))
    end
    if cache[seq][i] == -1
      cache[seq][i] = prices[i, j]
    end
  end

  maxseq = reduce((x, y) -> sum(cache[x]) ≥ sum(cache[y]) ? x : y, keys(cache))
  return sum(x -> max(x, 0), cache[maxseq])
end

part2(input)