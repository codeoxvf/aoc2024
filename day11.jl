input = "125 17"
input = strip(read("input11", String))

function part1(input)
  function step(stones)
    newstones = []
    for s in stones
      if s == 0
        push!(newstones, 1)
        continue
      end
      d = string(s)
      if length(d) % 2 == 0
        n = length(d) ÷ 2
        push!(newstones, parse(Int, d[begin:n]), parse(Int, d[n+1:end]))
        continue
      end
      push!(newstones, 2024s)
    end
    return newstones
  end

  input = [parse.(Int, i) for i in split(input, ' ')]
  for _ in 1:25
    input = step(input)
  end

  return length(input)
  function step(stones, n)
    newstones = []
    for s in stones
      if s == 0
        push!(newstones, 1)
        continue
      end
      d = string(s)
      if length(d) % 2 == 0
        n = length(d) ÷ 2
        push!(newstones, parse(Int, d[begin:n]), parse(Int, d[n+1:end]))
        continue
      end
      push!(newstones, 2024s)
    end
    return newstones
  end

  input = [parse.(Int, i) for i in split(input, ' ')]
  for _ in 1:25
    input = step(input)
  end

  return length(input)
end

function part2(input)
  #=function step(stones)
    replace!(stones, 0 => 1)
    replace!(stones) do s
      if length(string(s)) % 2 != 0 && s != 1
        2024s
      else
        s
      end
    end
    i = 0
    while !isnothing(i)
      i = findnext(s -> length(string(s)) % 2 == 0, stones, i + 1)
      d = string(stones[i])
      n = length(d) ÷ 2
      stones[i] = parse(Int, d[begin:n])
      insert!(stones, i + 1, parse(Int, d[n+1:end]))
    end
  end

  input = [parse.(Int, i) for i in split(input, ' ')]
  stones = zeros(Int, length(input))=#
end

println(part2(input))