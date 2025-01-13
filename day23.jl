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
  function getnetworkgraph(netmap)
    graph = Dict()
    for m in eachmatch(r"(..)-(..)", netmap)
      c = m.captures
      if c[1] ∈ keys(graph)
        push!(graph[c[1]], c[2])
      else
        graph[c[1]] = Set([c[2]])
      end
      if c[2] ∈ keys(graph)
        push!(graph[c[2]], c[1])
      else
        graph[c[2]] = Set([c[1]])
      end
    end
    return graph
  end

  function bronkerbosch!(graph, R, P, X, output)
    if isempty(P) && isempty(X)
      push!(output, R)
    end

    foreach(P) do v
      bronkerbosch!(graph, R ∪ Set([v]), P ∩ graph[v], X ∩ graph[v], output)
      delete!(P, v)
      push!(X, v)
    end
  end

  graph = getnetworkgraph(input)
  output = []
  bronkerbosch!(graph, Set(), Set(keys(graph)), Set(), output)
  lanparty = argmax(length, output)
  return println(join(sort(collect(lanparty)), ','))
end

part2(input)