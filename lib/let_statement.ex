defmodule LetStatement do
  import Helpers

  # end of statement
  def compile([%{symbol: :";"} | left_over_tokens], level) do
    IO.puts("... LetStatement 1")
    symbol(";", level) <>
    indent(level - 1) <> "</letStatement>\n"<>
    Statements.compile(left_over_tokens, level - 1)
  end

  def compile([%{symbol: :"["} | left_over_tokens], level) do
    IO.puts("... LetStatement 2")
    symbol("[", level) <>
    Expression.compile(left_over_tokens, level, callback: &LetStatement.compile/2)
  end

  def compile([%{symbol: :"]"} | left_over_tokens], level) do
    IO.puts("... LetStatement 3")
    symbol("]", level) <>
    compile(left_over_tokens, level)
  end

  def compile([%{symbol: :"="} | left_over_tokens], level) do
    IO.puts("... LetStatement 4")
    symbol("=", level) <>
    Expression.compile(left_over_tokens, level, callback: &LetStatement.compile/2)
  end

  def compile([%{keyword: :let},
               %{identifier: varName} | left_over_tokens], level) do
    IO.puts("... LetStatement 4")
    indent(level) <> "<letStatement>\n" <>
    keyword(:let, level + 1) <>
    identifier(varName, level + 1) <>
    compile(left_over_tokens, level + 1)
  end
end
