defmodule FlatCompilationEngine do
  def compile(%{tokens: tokens}) do
    "<tokens>\n" <> compile(tokens) <> "</tokens>\n"
  end

  def compile(tokens) when is_list(tokens) do
    Enum.reduce(tokens, "",  &(&2 <> compile(&1)))
  end

  def compile(%{keyword: value}) do
    "<keyword> " <> Atom.to_string(value) <> " </keyword>\n"
  end

  def compile(%{symbol: symbol}) do
    symbol =
      case Atom.to_string(symbol) do
        "<" -> "&lt;"
        ">" -> "&gt;"
        "&" -> "&amp;"
        x -> x
      end
    "<symbol> " <> symbol <> " </symbol>\n"
  end

  def compile(%{integer: int_const}) do
    "<integerConstant> " <> Integer.to_string(int_const) <> " </integerConstant>\n"
  end

  def compile(%{string: string_const}) do
    "<stringConstant> " <> string_const <> " </stringConstant>\n"
  end

  def compile(%{identifier: identifier}) do
    "<identifier> " <> identifier <> " </identifier>\n"
  end
end
