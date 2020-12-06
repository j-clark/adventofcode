lines = File.read(File.join(File.dirname(__FILE__), "input.txt")).lines

tree = {}

lines.each do |line|
  parent, children = line.split(/ -> /)

  name, weight = parent.split(" (")
  weight = weight.to_i

  current_node = tree[name] || {}
  tree[name] = {
    weight: weight,
    parent: current_node[:parent] || nil,
    children: current_node[:children] || []
  }

  if children
    children.split(", ").map(&:strip).each do |child|
      current_child = tree[child] || {}
      tree[child] = {
        weight: current_child[:weight],
        parent: name,
        children: current_child[:children] || []
      }
      tree[name][:children].push(child)
    end
  end
end

root = tree.keys.first
root = tree[root][:parent] until tree[root][:parent].nil?
puts "part 1: #{root}"

def weight(node, tree)
  tree[node][:weight] + tree[node][:children].map { |n| weight(n, tree) }.reduce(&:+).to_i
end

def find_last_unbalanced(node_name, tree)
  node = tree[node_name]
  children = node[:children]
  subweights = children.map { |n| [n, weight(n, tree)] }.to_h
  return node_name if subweights.values.uniq.one?

  unbalanced = subweights
    .group_by(&:last)
    .find { |_, groups| groups.count == 1 }.last.first.first

  find_last_unbalanced(unbalanced, tree)
end

last_unbalanced = find_last_unbalanced(root, tree)
diff = tree[tree[last_unbalanced][:parent]][:children]
  .map { |n| weight(n, tree) }
  .uniq.reduce(&:-).abs
puts "part 2: #{(diff - tree[last_unbalanced][:weight]).abs}"
