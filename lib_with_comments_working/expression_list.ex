defmodule ExpressionList do
  import Helpers

  # end of statement
  def compile([%{symbol: symbol} | _] = tokens, level, stack)
  when symbol in [:")", :";"] do
    IO.puts("... ExpressionList 1")
    indent(level - 1) <> "</expressionList>\n"<>
    SubroutineCall.compile(tokens, level - 1, stack)
  end

  def compile([%{symbol: :","} | left_over_tokens], level, stack) do
    IO.puts("... ExpressionList 2")
    symbol(",", level) <>
    compile(left_over_tokens, level, stack)
  end

  def compile([%{start: true} | left_over_tokens], level, stack) do
    IO.puts("... ExpressionList 3")
    indent(level) <> "<expressionList>\n"<>
    compile(left_over_tokens, level + 1, stack)
  end

  def compile(tokens, level, stack) do
    IO.puts("... ExpressionList 4")
    Expression.compile(tokens, level, [&ExpressionList.compile/3 | stack])
  end
end
