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
  function step(stones)
    nstones = typeof(stones)()

    foreach(keys(stones)) do i
      i == 0 && return

      s = string(i)
      if length(s) % 2 == 0
        a = parse(Int, s[1:length(s)÷2])
        b = parse(Int, s[length(s)÷2+1:end])
        nstones[a] = get(nstones, a, 0) + stones[i]
        nstones[b] = get(nstones, b, 0) + stones[i]
      else
        nstones[2024i] = get(nstones, 2024i, 0) + stones[i]
      end
    end

    nstones[1] = get(nstones, 1, 0) + get(stones, 0, 0)

    return nstones
  end

  input = map(i -> parse(Int, i), split(input, ' '))
  stones = Dict(map(i -> i => count(x -> x == i, input), unique(input)))

  for _ in 1:75
    stones = step(stones)
  end

  sum(x -> x[2], stones)
end

println(part2(input))