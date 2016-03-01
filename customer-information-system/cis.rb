require './parser'

# Traverse the graph to compute the total time for the route
def travel_time(graph, *nodes)
  sum = nodes.each_cons(2).map { |u, v| graph[u][v] }
  sum.last ? sum.reduce(:+) : 'Itinerary not possible'
end

# Modified Depth-First-Search with backtracking to find all paths
def dfs(graph, source, target, condition, terminate)
  results       = []
  stack         = []
  current_route = []

  # Visited routes
  routes = Hash.new { |h,k| h[k] = [] }

  # Initialize
  stack.push(source)

  while !stack.empty?
    node = stack.pop
    current_route << node
    routes[node] << current_route.dup

    stops = current_route.size - 1 
    requirement = condition.call(stops)
    backtrack = terminate.call(stops)

    # Destination reached?
    terminus = current_route.first == source && current_route.last == target

    # Abort if destination is reached or success condition is violated
    if (requirement && terminus) || (!terminus && backtrack)
      if terminus
        results << current_route.dup
      end

      # We're done
      if stack.empty?
        return results
      end

      # Backtrack
      current_route.pop
      node = current_route.last
      # Go back until an alternative path has been found that has not been walked yet
      while graph[node].keys.all? { |adj| routes[adj].any? { |route| route == current_route + [adj]  } }
        current_route.pop
        node = current_route.last
      end
    else
      # Going forward
      graph[node].each do |adj, _|
        stack.push(adj)
      end
    end

  end

  return routes
end

def floyd_warshal(graph)
  dist = Hash.new { |h,k| h[k] = Hash.new(Float::INFINITY) }
  graph.keys { |v| dist[v][v] = 0 }
  graph.each { |u, edges| edges.each { |v, w| dist[u][v] = w } }

  nodes = graph.keys

  nodes.each do |k|
    nodes.each do |i|
      nodes.each do |j|
        if dist[i][j] > dist[i][k] + dist[k][j]
          dist[i][j] = dist[i][k] + dist[k][j]
        end
      end
    end
  end

  dist
end

def combine(graph, routes)
  results = routes
  results.reject! { |r| travel_time(graph, *r) >= 30 }

  rs = routes.dup
  rx = routes.dup

  while !rs.empty?
    r1 = rs.first
    while !rx.empty?
      r2 = rx.first

      candidate_1 = (r1.take(r1.size - 1) + r2)
      candidate_2 = (r2.take(r2.size - 1) + r1)

      if travel_time(graph, *candidate_1) < 30
        results << candidate_1
        rs << candidate_1
        rx << candidate_1
      end

      if travel_time(graph, *candidate_2) < 30
        results << candidate_2
        rs << candidate_2
        rx << candidate_2
      end

      rx.shift
    end
    rs.shift
  end

  results.uniq
end

graph = Parser.parse('routes.txt')
cost = floyd_warshal(graph)

# Question 1-5
puts travel_time(graph, 'M', 'N', 'L')
puts travel_time(graph, 'M', 'P')
puts travel_time(graph, 'M', 'P', 'L')
puts travel_time(graph, 'M', 'R', 'N', 'L', 'P')
puts travel_time(graph, 'M', 'R', 'P')

# Question 6-7
puts dfs(graph, 'L', 'L', lambda { |n| n <= 3 && n > 1}, lambda { |n| n >= 4 }).size
puts dfs(graph, 'M', 'L', lambda { |n| n == 4 }, lambda { |n| n > 4 }).size

# Question 8-9
puts cost['M']['L']
puts cost['N']['N']

# Question 10
routes = dfs(graph, 'L', 'L', lambda { |n| n <= graph.size && n > 1}, lambda { |n| n >= graph.size })
puts combine(graph, routes).size
