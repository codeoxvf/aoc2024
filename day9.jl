input = "2333133121414131402"
input = strip(read("input9", String))

function part1(input)
  disk::Vector{Int} = []
  id = 0
  for i in eachindex(input)
    l = parse(Int, input[i])
    append!(disk, [i % 2 == 0 ? -1 : id for _ in 1:l])
    if i % 2 == 0
      id += 1
    end
  end

  for i in eachindex(disk)
    disk[i] != -1 && continue
    b = findlast(x -> x != -1, disk)
    b <= i && continue
    disk[i] = disk[b]
    disk[b] = -1
  end

  checksum = 0
  for i in eachindex(disk)
    disk[i] == -1 && continue
    checksum += disk[i] * (i - 1)
  end

  return checksum
end

function part2(input)
  function filerange(disk, i)
    a = b = i
    while checkbounds(Bool, disk, a - 1) && disk[a-1] == disk[i]
      a -= 1
    end
    while checkbounds(Bool, disk, b + 1) && disk[b+1] == disk[i]
      b += 1
    end
    return a:b
  end

  disk::Vector{Int} = []
  id = 0
  for i in eachindex(input)
    l = parse(Int, input[i])
    append!(disk, [i % 2 == 0 ? -1 : id for _ in 1:l])
    if i % 2 == 0
      id += 1
    end
  end

  for i in reverse(eachindex(disk))
    f = filerange(disk, i)
    for j in findall(x -> x == -1, disk[begin:i])
      s = filerange(disk, j)
      if length(s) >= length(f)
        disk[s[begin:begin+length(f)-1]] = disk[f]
        disk[f] .= -1
        break
      end
    end
  end

  checksum = 0
  for i in findall(x -> x != -1, disk)
    checksum += disk[i] * (i - 1)
  end

  return checksum
end

println(part2(input))