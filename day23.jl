using Combinatorics

example = """kh-tc
qp-kh
de-cg
ka-co
yn-aq
qp-ub
cg-tb
vc-aq
tb-ka
wh-tc
yn-cg
kh-ub
ta-co
de-co
tc-td
tb-wq
wh-td
ta-ka
td-qp
aq-cg
wq-ub
ub-vc
de-ta
wq-aq
wq-vc
wh-yn
ka-de
kh-ta
co-tc
wh-qp
tb-vc
td-yn"""
input = read("input23", String)
#input = split(read("input", String), "\n\n")

function part1(input)
  netmap = Dict()
  for m in eachmatch(r"(..)-(..)", input)
    c = m.captures
    if c[1] ∈ keys(netmap)
      push!(netmap[c[1]], c[2])
    else
      netmap[c[1]] = [c[2]]
    end
    if c[2] ∈ keys(netmap)
      push!(netmap[c[2]], c[1])
    else
      netmap[c[2]] = [c[1]]
    end
  end

  interconnections = Set()
  for (name, connections) in netmap, pair in combinations(connections, 2)
    if pair[1] ∈ netmap[pair[2]]
      push!(interconnections, Set([name, pair[1], pair[2]]))
    end
  end

  return sum(interconnections) do x
    for i in x
      i[1] == 't' && return true
    end
    return false
  end
end

function part2(input)
  netmap = Dict()
  for m in eachmatch(r"(..)-(..)", input)
    c = m.captures
    if c[1] ∈ keys(netmap)
      push!(netmap[c[1]], c[1], c[2])
    else
      netmap[c[1]] = Set([c[1], c[2]])
    end
    if c[2] ∈ keys(netmap)
      push!(netmap[c[2]], c[1], c[2])
    else
      netmap[c[2]] = Set([c[1], c[2]])
    end
  end

  largestset = Set()
  for connections in values(netmap),
    currsubset in combinations(collect(connections))

    if length(currsubset) < max(3, length(largestset))
      continue
    end

    connectedsubset = Set(reduce(∩, [netmap[c] for c in currsubset]))
    if length(connectedsubset) > length(largestset)
      largestset = connectedsubset
    end
  end

  println(join(sort(collect(largestset)), ','))
end

part2(input)