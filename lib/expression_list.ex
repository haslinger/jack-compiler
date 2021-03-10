defmodule ExpressionList do
  import Helpers

  # end of statement
  def compile([%{symbol: :")"} | _] = tokens, level) do
    IO.puts("... ExpressionList 1")
    indent(level - 1) <> "</expressionList>\n"<>
    SubroutineCall.compile(tokens, level - 1)
  end

  def compile([%{symbol: :","} | left_over_tokens], level) do
    IO.puts("... ExpressionList 2")
    symbol(",", level) <>
    compile(left_over_tokens, level)
  end

  def compile([%{start: true} | left_over_tokens], level) do
    IO.puts("... Expression 3")
    indent(level) <> "<expressionList>\n"<>
    compile(left_over_tokens, level + 1)
  end

  def compile(tokens, level) do
    IO.puts("... Expression 4")
    Expression.compile(tokens, level, callback: &ExpressionList.compile/2)
  end
end
