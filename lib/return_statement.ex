defmodule ReturnStatement do
  import Helpers

  # end of statement
  def compile([%{symbol: :";"} | left_over_tokens], level, [callback | stack]) do
    IO.puts("... ReturnStatement 1")
    symbol(";", level) <>
    indent(level - 1) <> "</returnStatement>\n"<>
    callback.(left_over_tokens, level - 1, stack)
  end

  def compile([%{keyword: :return} | left_over_tokens], level, stack) do
    IO.puts("... ReturnStatement 2")
    indent(level) <> "<returnStatement>\n" <>
    keyword(:return, level + 1) <>
    compile(left_over_tokens, level + 1, stack)
  end

  def compile(tokens, level, stack) do
    IO.puts("... ReturnStatement 3")
    Expression.compile(tokens, level, [&ReturnStatement.compile/3 | stack])
  end
end
