defmodule VariableDeclaration do
  import Helpers

  # ("," varName)*
  def compile([%{symbol: :","},
               %{identifier: varName} | left_over_tokens], level) do
    IO.puts("=== VariableDeclaration 1 ===")
    symbol(",", level) <>
    identifier(varName, level) <>
    compile(left_over_tokens, level)
  end

  #";"
  def compile([%{symbol: :";"} | left_over_tokens], level) do
    IO.puts("=== VariableDeclaration 2 ===")
    symbol(";", level) <>
    indent(level- 1) <> "</varDec>\n" <>
    SubroutineBody.compile(left_over_tokens, level - 1)
  end
end
