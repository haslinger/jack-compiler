defmodule DoStatement do
  import Helpers

  # end of statement
  def compile([%{symbol: :";"} | left_over_tokens], level, [callback | stack]) do
    symbol(";", level) <>
    indent(level - 1) <> "</doStatement>\n"<>
    callback.(left_over_tokens, level - 1, stack)
  end

  def compile([%{keyword: :do} | left_over_tokens], level, stack) do
    indent(level) <> "<doStatement>\n" <>
    keyword(:do, level + 1) <>
    SubroutineCall.compile(left_over_tokens, level + 1, [&DoStatement.compile/3 | stack])
  end
end
