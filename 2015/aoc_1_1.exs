{ _status, contents } = File.read(Path.expand("~/workspace/adventofcode/2015/aoc_1_input.txt"))
String.split(contents, "", trim: true)
|> Enum.reduce(0, fn x, acc ->
  cond do
    x == "(" ->
      acc + 1
    x == ")" ->
      acc - 1
    x != ")" ->
      acc
  end
end
)
|> IO.puts
