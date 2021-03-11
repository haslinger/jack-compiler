defmodule LetStatement do
  import Helpers

  # end of statement
  def compile([%{symbol: :";"} | left_over_tokens], level, [callback | stack]) do
    symbol(";", level) <>
    indent(level - 1) <> "</letStatement>\n"<>
    callback.(left_over_tokens, level - 1, stack)
  end

  def compile([%{symbol: :"["} | left_over_tokens], level, stack) do
    symbol("[", level) <>
    Expression.compile(left_over_tokens, level, [&LetStatement.compile/3 | stack])
  end

  def compile([%{symbol: :"]"} | left_over_tokens], level, stack) do
    symbol("]", level) <>
    compile(left_over_tokens, level, stack)
  end

  def compile([%{symbol: :"="} | left_over_tokens], level, stack) do
    symbol("=", level) <>
    Expression.compile(left_over_tokens, level, [&LetStatement.compile/3 | stack])
  end

  def compile([%{keyword: :let},
               %{identifier: varName} | left_over_tokens], level, stack) do
    indent(level) <> "<letStatement>\n" <>
    keyword(:let, level + 1) <>
    identifier(varName, level + 1) <>
    compile(left_over_tokens, level + 1, stack)
  end
end
