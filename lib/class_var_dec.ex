defmodule ClassVarDec do
  import Helpers

  # type :int | :char | :boolean varName
  def compile([%{keyword: keyword},
               %{identifier: varname} | left_over_tokens], level)
    when keyword in [:int, :char, :boolean] do
    IO.puts("... ClassVarDec 1")
    keyword(keyword, level) <>
    identifier(varname, level) <>
    compile(left_over_tokens, level)
  end

  # type className varName
  def compile([%{identifier: className},
               %{identifier: varName} | left_over_tokens], level) do
    IO.puts("... ClassVarDec 2")
    identifier(className, level) <>
    identifier(varName, level) <>
    compile(left_over_tokens, level)
  end

  # ,varName *
  def compile([%{symbol: :","},
               %{identifier: varName} | left_over_tokens], level) do
    IO.puts("... ClassVarDec 3")
    identifier(varName, level) <>
    compile(left_over_tokens, level)
  end

  # ;
  def compile([%{symbol: :";"} | left_over_tokens], level) do
    IO.puts("... ClassVarDec 4")
    indent(level - 1) <> "</classVarDec>\n" <>
    ClassBody.compile(left_over_tokens, level - 1);
  end
end
