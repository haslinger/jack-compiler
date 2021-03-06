defmodule Helpers do
  def indent(level) do
    indent_by_spaces = 2
    String.duplicate(" ", level * indent_by_spaces)
  end

  def keyword(value, level), do: terminal(:keyword, Atom.to_string(value), level)
  def identifier(value, level), do: terminal(:identifier, value, level)
  def symbol(symbol, level) do
    symbol =
      case symbol do
        "<" -> "&lt;"
        ">" -> "&gt;"
        "&" -> "&amp;"
        x -> x
      end
    terminal(:symbol, symbol, level)
  end
  def integer(value, level), do: terminal(:integerConstant, Integer.to_string(value), level)
  def string(value, level), do: terminal(:stringConstant, value, level)

  def terminal(tag, value, level) do
    indent(level) <> #indentation
    "<" <> Atom.to_string(tag) <> "> " <> # Opening Tag
    value <> # Value
    " </" <> Atom.to_string(tag) <> ">\n" # Closing Tag + Newline
  end
end
