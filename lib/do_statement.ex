defmodule DoStatement do
  import Helpers

  # end of statement
  def compile([%{symbol: :";"} | left_over_tokens], level, [callback | stack]) do
    IO.puts("... DoStatement 1")
    symbol(";", level) <>
    indent(level - 1) <> "</doStatement>\n"<>
    callback.(left_over_tokens, level - 1, stack)
  end

  def compile([%{keyword: :do} | left_over_tokens], level, stack) do
    IO.puts("... DoStatement 2")
    indent(level) <> "<doStatement>\n" <>
    keyword(:do, level + 1) <>
    SubroutineCall.compile(left_over_tokens, level + 1, stack)
  end
end
