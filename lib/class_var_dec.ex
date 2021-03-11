defmodule ClassVarDec do
  import Helpers

  # ;
  def compile([%{symbol: :";"} | left_over_tokens], level, stack) do
    symbol(";", level) <>
    indent(level - 1) <> "</classVarDec>\n" <>
    ClassBody.compile(left_over_tokens, level - 1, stack);
  end

  # ,varName *
  def compile([%{symbol: :","},
               %{identifier: varName} | left_over_tokens], level, stack) do
  symbol(",", level) <>
  identifier(varName, level) <>
  compile(left_over_tokens, level, stack)
  end

  # type :int | :char | :boolean varName
  def compile([%{keyword: static_or_field},
               %{keyword: type},
               %{identifier: varname} | left_over_tokens], level, stack)
    when type in [:int, :char, :boolean] do
    indent(level) <> "<classVarDec>\n" <>
    keyword(static_or_field, level + 1) <>
    keyword(type, level + 1) <>
    identifier(varname, level + 1) <>
    compile(left_over_tokens, level + 1, stack)
  end

  # type className varName
  def compile([%{keyword: static_or_field},
               %{identifier: className},
               %{identifier: varName} | left_over_tokens], level, stack) do
    indent(level) <> "<classVarDec>\n" <>
    keyword(static_or_field, level + 1) <>
    identifier(className, level + 1) <>
    identifier(varName, level + 1) <>
    compile(left_over_tokens, level + 1, stack)
  end
end
