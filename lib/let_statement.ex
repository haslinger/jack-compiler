defmodule LetStatement do
  import Helpers

  # end of statement
  def compile([%{symbol: :";"} | left_over_tokens ], level) do
    IO.puts("... LetStatement 1")
    symbol(";", level) <>
    indent(level - 1) <> "</letStatement>\n"<>
    Statements.compile(left_over_tokens, level - 1)
  end

  def compile([%{identifier: varName},
                  %{symbol: :"="} | left_over_tokens], level) do
    IO.puts("... LetStatement 2")
    keyword(:let, level) <>
    identifier(varName, level) <>
    symbol("=", level) <>
    indent(level) <> "<expression>\n"<>
    Expression.compile(left_over_tokens, level, callback: &LetStatement.compile/2)
  end
end
