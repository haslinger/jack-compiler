defmodule ParameterList do
  import Helpers

  # ")"
  def compile([%{symbol: :")"} | _] = tokens, level, stack) do
    indent(level - 1) <> "</parameterList>\n" <>
    SubroutineDec.compile(tokens, level - 1, stack)
  end

  # type :void | :int | :char varName
  def compile([%{start: true} | left_over_tokens], level, stack) do
    indent(level) <> "<parameterList>\n" <>
    compile(left_over_tokens, level + 1, stack)
  end

  #  ","
  def compile([%{symbol: :","} | left_over_tokens], level, stack) do
    symbol(",", level) <>
    compile(left_over_tokens, level, stack)
  end

  # type :void | :int | :char varName
  def compile([%{keyword: keyword},
               %{identifier: varName} | left_over_tokens], level, stack)
  when keyword in [:int, :char, :boolean] do
    keyword(keyword, level) <>
    identifier(varName, level) <>
    compile(left_over_tokens, level, stack)
  end

  #  type className varName
  def compile([%{identifier: className},
               %{identifier: varName} | left_over_tokens], level, stack) do
    identifier(className, level) <>
    identifier(varName, level) <>
    compile(left_over_tokens, level, stack)
  end
end
