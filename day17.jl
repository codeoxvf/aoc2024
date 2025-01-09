example = split("""Register A: 2024
Register B: 0
Register C: 0

Program: 0,3,5,4,3,0""", '\n')
input = readlines("input17")
#input = split(read("input17", String), "\n\n")

function part1(input)
  registerA = parse(BigInt, match(r"Register .: (\d+)", input[1]).captures[1])
  registerB = parse(BigInt, match(r"Register .: (\d+)", input[2]).captures[1])
  registerC = parse(BigInt, match(r"Register .: (\d+)", input[3]).captures[1])
  program = parse.(BigInt, split(match(r"Program: (.*)", input[5]).captures[1], ','))
  output::Vector{BigInt} = []
  instrpointer = 0
  jump = false

  while checkbounds(Bool, program, instrpointer+1)
    instr = program[instrpointer+1]
    literal = program[instrpointer+2]

    # calculate value for those instructions that use combo operand
    combo = if literal <= 3
      literal
    elseif literal == 4
      registerA
    elseif literal == 5
      registerB
    elseif literal == 6
      registerC
    end

    if instr == 0
      registerA = trunc(BigInt, registerA / 2^combo)
    elseif instr == 1
      registerB = registerB ⊻ literal
    elseif instr == 2
      registerB = combo % 8
    elseif instr == 3
      if registerA == 0
        instrpointer += 2
        continue
      end
      instrpointer = literal
      jump = true
    elseif instr == 4
      registerB = registerB ⊻ registerC
    elseif instr == 5
      push!(output, combo % 8)
    elseif instr == 6
      registerB = trunc(BigInt, registerA / 2^combo)
    elseif instr == 7
      registerC = trunc(BigInt, registerA / 2^combo)
    end

    if jump
      jump = false
    else
      instrpointer += 2
    end
  end

  return join(output, ',')
end

function part2(input)
  # Program: 2,4,1,3,7,5,1,5,0,3,4,3,5,5,3,0
  program = match(r"Program: (.*)", input[5]).captures[1]
  i = 0
  while true
    newinput = replace(input, r"Register A: \d+" => "Register A: $i")
    if part1(newinput) == program
      return i
    end
    i += 1
  end
end

println(part2(input))