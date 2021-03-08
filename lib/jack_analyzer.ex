defmodule JackAnalyzer do
  def main(args) do
    { _, [directory | _], _ } = OptionParser.parse(args, strict: [])

    # Create output directory, if it doesn't exist
    File.mkdir_p!("../" <> directory <> "/output")

    "../" <> directory <> "/*.jack"
    |> Path.wildcard()
    |> Enum.each(&process(&1, directory))
  end

  def process(file, directory) do
    {:ok, body} = File.read(file)

    filename = file |> Path.basename() |> String.split(".") |> List.first()
    output_path = "../" <> directory <> "/output/" <> filename <> "T.xml"
    {:ok, file} = File.open(output_path, [:write, :utf8])

    output =
      body
      |> JackTokenizer.parse()
      |> CompilationEngine.xml_tokens()

    IO.write(file, output)
  end
end
