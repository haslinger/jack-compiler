defmodule ReturnStatement do
  import Helpers

  # end of statement
  def compile([%{symbol: :";"} | left_over_tokens], level) do
    IO.puts("... ReturnStatement 1")
    symbol(";", level) <>
    indent(level - 1) <> "</returnStatement>\n"<>
    Statements.compile(left_over_tokens, level - 1)
  end

  def compile([%{keyword: :return} | left_over_tokens], level) do
    IO.puts("... ReturnStatement 2")
    keyword(:return, level) <>
    compile(left_over_tokens, level)
  end

  def compile([%{identifier: variableName} | left_over_tokens], level) do
    IO.puts("... ReturnStatement 3")
    identifier(variableName, level) <>
    compile(left_over_tokens, level)
  end
end
