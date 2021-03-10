defmodule ExpressionList do
  import Helpers

  # end of statement
  def compile([%{symbol: :")"} | _] = tokens, level) do
    IO.puts("... ExpressionList 1")
    indent(level - 1) <> "</expressionList>\n"<>
    SubroutineCall.compile.(tokens, level - 1)
  end

  def compile([%{symbol: :","} | left_over_tokens], level) do
    IO.puts("... ExpressionList 2")
    symbol(",", level) <>
    Expression.compile(left_over_tokens, level, callback: &ExpressionList.call/2)
  end

  def compile(tokens, level) do
    IO.puts("... Expression 3")
    indent(level + 1) <> "<expressionsList>\n"<>
    Expression.compile(tokens, level + 1, callback: &ExpressionList.call/2)
  end
end
