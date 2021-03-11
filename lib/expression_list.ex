defmodule ExpressionList do
  import Helpers

  # end of statement
  def compile([%{symbol: symbol} | _] = tokens, level, stack)
  when symbol in [:")", :";"] do
    indent(level - 1) <> "</expressionList>\n"<>
    SubroutineCall.compile(tokens, level - 1, stack)
  end

  def compile([%{symbol: :","} | left_over_tokens], level, stack) do
    symbol(",", level) <>
    compile(left_over_tokens, level, stack)
  end

  def compile([%{start: true} | left_over_tokens], level, stack) do
    indent(level) <> "<expressionList>\n"<>
    compile(left_over_tokens, level + 1, stack)
  end

  def compile(tokens, level, stack) do
    Expression.compile(tokens, level, [&ExpressionList.compile/3 | stack])
  end
end
