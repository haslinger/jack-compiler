defmodule JackAnalyzer do
  def main(args) do
    { _, [directory | _], _ } = OptionParser.parse(args, strict: [])

    "../" <> directory <> "/*.jack"
    |> Path.wildcard()
    |> Enum.each(&process(&1))
  end

  def process(file) do
    {:ok, body} = File.read(file)
    IO.inspect body
  end
end