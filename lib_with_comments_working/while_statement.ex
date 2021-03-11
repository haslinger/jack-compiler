defmodule WhileStatement do
  import Helpers

  # end of statement
  def compile([%{symbol: :"}"} | left_over_tokens], level, [callback | stack]) do
    IO.puts("... WhileStatement 2")
    symbol("}", level) <>
    indent(level - 1) <> "</whileStatement>\n"<>
    callback.(left_over_tokens, level - 1, stack)
  end

  def compile([%{keyword: :while},
               %{symbol: :"("} | left_over_tokens], level, stack) do
    IO.puts("... WhileStatement 3")
    indent(level) <> "<whileStatement>\n" <>
    keyword(:while, level + 1) <>
    symbol("(", level + 1) <>
    Expression.compile(left_over_tokens, level + 1, [&WhileStatement.compile/3 | stack])
  end

  def compile([%{symbol: :")"},
               %{symbol: :"{"} | left_over_tokens], level, stack) do
    IO.puts("... WhileStatement 4")
    symbol(")", level) <>
    symbol("{", level) <>
    Statements.compile(left_over_tokens, level, [&WhileStatement.compile/3 | stack])
  end
end
