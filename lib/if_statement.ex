defmodule IfStatement do
  import Helpers

  # else clause
  def compile([%{symbol: :"}"},
               %{keyword: :else},
               %{symbol: :"("} | left_over_tokens], level, stack) do
    symbol("}", level) <>
    keyword("else", level)
    symbol("{", level) <>
    Statements.compile(left_over_tokens, level, [&IfStatement.compile/3 | stack])
  end

  # end of statement
  def compile([%{symbol: :"}"} | left_over_tokens], level, [callback | stack]) do
    symbol("}", level) <>
    indent(level - 1) <> "</ifStatement>\n"<>
    callback.(left_over_tokens, level - 1, stack)
  end

  def compile([%{keyword: :if},
               %{symbol: :"("} | left_over_tokens], level, stack) do
    indent(level) <> "<ifStatement>\n" <>
    keyword(:if, level + 1) <>
    symbol("(", level + 1) <>
    Expression.compile(left_over_tokens, level + 1, [&IfStatement.compile/3 | stack])
  end

  def compile([%{symbol: :")"},
               %{symbol: :"{"} | left_over_tokens], level, stack) do
    symbol(")", level) <>
    symbol("{", level) <>
    Statements.compile(left_over_tokens, level, [&IfStatement.compile/3 | stack])
  end
end
