defmodule DoStatement do
  import Helpers

  # end of statement
  def compile([%{symbol: :";"} | left_over_tokens], level) do
    IO.puts("... DoStatement 1")
    symbol(";", level) <>
    indent(level - 1) <> "</doStatement>\n"<>
    Statements.compile(left_over_tokens, level - 1)
  end

  def compile([%{keyword: :do} | left_over_tokens], level) do
    indent(level) <> "<doStatement>\n" <>
    keyword(:do, level + 1) <>
    SubroutineCall.call(left_over_tokens, level + 1)
  end
end
