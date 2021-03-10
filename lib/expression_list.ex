defmodule Expression do
  import Helpers

  # end of statement
  def compile([%{symbol: :")"} | _ ] = tokens, level, callback: callback) do
    IO.puts("... ExpressionList 1")
    indent(level - 1) <> "</expressionList>\n"<>
    symbol(")", level) <>
    callback.(tokens, level - 1)
  end

  def compile([%{symbol: :","} | left_over_tokens ], level, callback: callback) do
    IO.puts("... ExpressionList 2")
    symbol(",", level) <>
    Expression.compile(left_over_tokens, level, callback: callback)
  end

  def compile([%{identifier: identifier} | left_over_tokens], level, callback: callback) do
    IO.puts("... Expression 3")
    indent(level + 1) <> "<expressionsList>\n"<>
    Expression.compile(left_over_tokens, level + 1, callback: callback)
  end
end
