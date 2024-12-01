using StatsBase

lines = readlines("input1")

function part1(lines)
  lines = hcat(map(l -> parse.(Int, l), split.(lines))...)
  sort!(lines; dims=2)

  distances = abs.(lines[1, :] - lines[2, :])
  println(sum(distances))
end

function part2(lines)
  similarity = 0
  lines = hcat(map(l -> parse.(Int, l), split.(lines))...)
  cm = countmap(lines[2, :])

  for n in lines[1, :]
    if haskey(cm, n)
      similarity += cm[n] * n
    end
  end

  println(similarity)
end

part2(lines)