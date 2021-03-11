defmodule VariableDeclaration do
  import Helpers

  # ("," varName)*
  def compile([%{symbol: :","},
               %{identifier: varName} | left_over_tokens], level, stack) do
    symbol(",", level) <>
    identifier(varName, level) <>
    compile(left_over_tokens, level, stack)
  end

  #";"
  def compile([%{symbol: :";"} | left_over_tokens], level, stack) do
    symbol(";", level) <>
    indent(level- 1) <> "</varDec>\n" <>
    SubroutineBody.compile(left_over_tokens, level - 1, stack)
  end
end
