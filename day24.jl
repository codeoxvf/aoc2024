example = split("""x00: 0
x01: 1
x02: 0
x03: 1
x04: 0
x05: 1
y00: 0
y01: 0
y02: 1
y03: 1
y04: 0
y05: 1

x00 AND y00 -> z05
x01 AND y01 -> z02
x02 AND y02 -> z01
x03 AND y03 -> z03
x04 AND y04 -> z04
x05 AND y05 -> z00""", "\n\n")
#input = readlines("input24")
input = split(read("input24", String), "\n\n")

function part1(input)
  wires = Dict(map(x -> x.captures[1] => parse(Int, x.captures[2]),
    eachmatch(r"(.\d\d): (.)", input[1])))
  gates = Dict(
    "XOR" => ⊻,
    "OR" => |,
    "AND" => &
  )
  retry = []

  for l in eachmatch(r"(...) (XOR|OR|AND) (...) -> (...)", input[2])
    c = l.captures
    if c[1] ∈ keys(wires) && c[3] ∈ keys(wires)
      wires[c[4]] = gates[c[2]](wires[c[1]], wires[c[3]])
    else
      push!(retry, c)
    end
  end

  while !isempty(retry)
    for (i, c) in enumerate(retry)
      if c[1] ∈ keys(wires) && c[3] ∈ keys(wires)
        wires[c[4]] = gates[c[2]](wires[c[1]], wires[c[3]])
        popat!(retry, i)
      end
    end
  end

  zwires = filter(x -> x !== false, map(collect(keys(wires))) do x
    x[1] == 'z' && return parse(Int, x[2:3])
  end)
  output = 0
  for n in zwires
    output |= wires['z'*lpad(string(n), 2, '0')] << n
  end
  output
end

function part2(input)
  function readnumber(prefix, wires)
    wirenumbers = filter(x -> x !== false, map(collect(keys(wires))) do x
      x[1] == prefix && return parse(Int, x[2:3])
    end)
    output = 0
    for n in wirenumbers
      output |= wires[prefix*lpad(string(n), 2, '0')] << n
    end
    return output
  end

  wires = Dict(map(x -> x.captures[1] => parse(Int, x.captures[2]),
    eachmatch(r"(.\d\d): (.)", input[1])))
  gates = Dict(
    "XOR" => ⊻,
    "OR" => |,
    "AND" => &
  )
  retry = []

  for l in eachmatch(r"(...) (XOR|OR|AND) (...) -> (...)", input[2])
    c = l.captures
    if c[1] ∈ keys(wires) && c[3] ∈ keys(wires)
      wires[c[4]] = gates[c[2]](wires[c[1]], wires[c[3]])
    else
      push!(retry, c)
    end
  end

  while !isempty(retry)
    for (i, c) in enumerate(retry)
      if c[1] ∈ keys(wires) && c[3] ∈ keys(wires)
        wires[c[4]] = gates[c[2]](wires[c[1]], wires[c[3]])
        popat!(retry, i)
      end
    end
  end

  x = readnumber('x', wires)
  y = readnumber('y', wires)
  z = readnumber('z', wires)
  println("x: ", string(x, base=2))
  println("y: ", string(y, base=2))
  println("z: ", string(z, base=2))
  println("x & y: ", string(x & y, base=2))
  println("difference ", string(z ⊻ (x & y), base=2))
end

part2(example)