defmodule IfStatement do
  import Helpers

  # else clause
  def compile([%{symbol: :"}"},
               %{keyword: :else},
               %{symbol: :"("} | left_over_tokens], level, stack) do
    IO.puts("... IfStatement 1")
    symbol("}", level) <>
    keyword("else", level)
    symbol("{", level) <>
    Statements.compile(left_over_tokens, level, [&IfStatement.compile/2 | stack])
  end

  # end of statement
  def compile([%{symbol: :"}"} | left_over_tokens], level, stack) do
    IO.puts("... IfStatement 2")
    symbol("}", level) <>
    indent(level - 1) <> "</ifStatement>\n"<>
    Statements.compile(left_over_tokens, level - 1, [&IfStatement.compile/2 | stack])
  end

  def compile([%{keyword: :if},
               %{symbol: :"("} | left_over_tokens], level, stack) do
    IO.puts("... IfStatement 3")
    indent(level) <> "<ifStatement>\n" <>
    keyword(:if, level + 1) <>
    symbol("(", level + 1) <>
    Expression.compile(left_over_tokens, level + 1, stack)
  end

  def compile([%{symbol: :")"},
               %{symbol: :"{"} | left_over_tokens], level, stack) do
    IO.puts("... IfStatement 4")
    symbol(")", level + 1) <>
    symbol("{", level + 1) <>
    Statements.compile(left_over_tokens, level + 1, stack)
  end
end
