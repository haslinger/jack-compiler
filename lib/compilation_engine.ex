defmodule CompilationEngine do
  def xml_tokens(map) do
    parse(map)
  end

  def parse(%{tokens: tokens}) do
    "<tokens>\n" <> parse(tokens) <> "</tokens>\n"
  end

  def parse(tokens) when is_list(tokens) do
    Enum.reduce(tokens, "",  &(&2 <> parse(&1)))
  end

  def parse(%{tokenType: :keyword, keyword: value}) do
    "<keyword> " <> Atom.to_string(value) <> " </keyword>\n"
  end

  def parse(%{tokenType: :symbol, symbol: symbol}) do
    symbol =
      case Atom.to_string(symbol) do
        "<" -> "&lt;"
        ">" -> "&gt;"
        "&" -> "&amp;"
        x -> x
      end
    "<symbol> " <> symbol <> " </symbol>\n"
  end

  def parse(%{tokenType: :int_const, value: int_const}) do
    "<integerConstant> " <> Integer.to_string(int_const) <> " </integerConstant>\n"
  end

  def parse(%{tokenType: :string_const, value: string_const}) do
    "<stringConstant> " <> string_const <> " </stringConstant>\n"
  end

  def parse(%{tokenType: :identifier, identifier: identifier}) do
    "<identifier> " <> identifier <> " </identifier>\n"
  end
end
