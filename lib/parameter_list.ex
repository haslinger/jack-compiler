defmodule ParameterList do
  import Helpers

  # type :void | :int | :char varName
  def compile([%{keyword: keyword},
               %{identifier: varName} | left_over_tokens], level)
  when keyword in [:int, :char, :boolean] do
    IO.puts("=== ParameterList 1 ===")
    keyword(keyword, level) <>
    identifier(varName, level) <>
    compile(left_over_tokens, level)
  end

  #  type className varName
  def compile([%{identifier: className},
               %{identifier: varName} | left_over_tokens], level) do
    IO.puts("=== ParameterList 2 ===")
    identifier(className, level) <>
    identifier(varName, level) <>
    compile(left_over_tokens, level)
  end

  #  "," type :void | :int | :char varName
  def compile([%{symbol: :","},
               %{keyword: keyword},
               %{identifier: varName} | left_over_tokens], level)
  when keyword in [:int, :char, :boolean] do
    IO.puts("=== ParameterList 3 ===")
    symbol(",", level) <>
    keyword(keyword, level) <>
    identifier(varName, level) <>
    compile(left_over_tokens, level)
  end

  #  "," type className varName
  def compile([%{symbol: :","},
               %{identifier: className},
               %{identifier: varName} | left_over_tokens], level) do
    IO.puts("=== ParameterList 4 ===")
    symbol(",", level) <>
    identifier(className, level) <>
    identifier(varName, level) <>
    compile(left_over_tokens, level)
  end

  # ")"
  def compile([%{symbol: :")"} | left_over_tokens], level) do
    IO.puts("=== ParameterList 5 ===")
    symbol(")", level) <>
    indent(level) <> "</parameterList>\n" <>
    SubroutineBody.compile(left_over_tokens, level - 1)
  end
end
