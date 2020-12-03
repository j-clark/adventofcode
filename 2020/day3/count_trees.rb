def count_trees(map:, right:, down:)
  row_index = 0
  col_index = 0
  num_rows = map.length
  num_cols = map.first.length
  tree_count = 0

  until row_index >= num_rows
    if map[row_index][col_index] == "#"
      tree_count += 1
    end
    row_index += down
    col_index = (col_index + right) % num_cols
  end

  tree_count
end
