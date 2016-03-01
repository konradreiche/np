class Parser
  def self.parse(filename)
    graph = Hash.new { |h,k| h[k] = {} }
    data = File.read(filename).delete("\n").split(', ')
    data.each_with_object(graph) do |edge, node|
      node[edge[0]][edge[1]] = edge[2].to_i
    end
  end
end
