using StatsBase

input = readlines("input1")

function part1(input)
  input = hcat(map(l -> parse.(Int, l), split.(input))...)
  sort!(input; dims=2)

  distances = abs.(input[1, :] - input[2, :])
  println(sum(distances))
end

function part2(input)
  similarity = 0
  input = hcat(map(l -> parse.(Int, l), split.(input))...)
  cm = countmap(input[2, :])

  for n in input[1, :]
    if haskey(cm, n)
      similarity += cm[n] * n
    end
  end

  println(similarity)
end

part2(input)