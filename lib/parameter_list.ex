defmodule ParameterList do
  import Helpers

  # ")"
  def compile([%{symbol: :")"} | _] = tokens, level, stack) do
    IO.puts("... ParameterList 1")
    indent(level - 1) <> "</parameterList>\n" <>
    SubroutineDec.compile(tokens, level - 1, stack)
  end

  # type :void | :int | :char varName
  def compile([%{start: true} | left_over_tokens], level, stack) do
    IO.puts("... ParameterList 2")
    indent(level) <> "<parameterList>\n" <>
    compile(left_over_tokens, level + 1, stack)
  end

  #  ","
  def compile([%{symbol: :","} | left_over_tokens], level, stack) do
    IO.puts("... ParameterList 3")
    symbol(",", level) <>
    compile(left_over_tokens, level, stack)
  end

  # type :void | :int | :char varName
  def compile([%{keyword: keyword},
               %{identifier: varName} | left_over_tokens], level, stack)
  when keyword in [:int, :char, :boolean] do
    IO.puts("... ParameterList 4")
    keyword(keyword, level + 1) <>
    identifier(varName, level + 1) <>
    compile(left_over_tokens, level + 1, stack)
  end

  #  type className varName
  def compile([%{identifier: className},
               %{identifier: varName} | left_over_tokens], level, stack) do
    IO.puts("... ParameterList 5")
    identifier(className, level + 1) <>
    identifier(varName, level + 1) <>
    compile(left_over_tokens, level + 1, stack)
  end
end
