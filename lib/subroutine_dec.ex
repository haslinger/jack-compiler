defmodule SubroutineDec do
  import Helpers

  def compile([%{symbol: :"}"} | left_over_tokens], level, stack) do
    IO.puts("... SubroutineDec 1")
    indent(level - 1) <> "</subroutineDec>\n" <>
    ClassBody.compile(left_over_tokens, level - 1, stack);
  end

  def compile([%{symbol: :")"} | left_over_tokens], level, stack) do
    IO.puts("... SubroutineDec 3")
    symbol(")", level) <>
    SubroutineBody.compile(left_over_tokens, level, stack)
  end

  # (:void | :int | :char | :boolean) subroutineName "("
  def compile([%{keyword: constructor_or_function_or_method},
               %{keyword: varType},
               %{identifier: subroutineName},
               %{symbol: :"("} | left_over_tokens], level, stack)
  when varType in [:void, :int, :char, :boolean] do
    IO.puts("... SubroutineDec 4")
    indent(level) <> "<subroutineDec>\n" <>
    keyword(constructor_or_function_or_method, level + 1) <>
    keyword(varType, level + 1) <>
    identifier(subroutineName, level + 1) <>
    symbol("(", level + 1) <>
    ParameterList.compile([%{start: true} | left_over_tokens], level + 1, stack)
  end

  # className subroutineName "("
  def compile([%{keyword: constructor_or_function_or_method},
               %{identifier: className},
               %{identifier: subroutineName},
               %{symbol: :"("} | left_over_tokens], level, stack) do
    IO.puts("... SubroutineDec 5")
    indent(level) <> "<subroutineDec>\n" <>
    keyword(constructor_or_function_or_method, level + 1) <>
    identifier(className, level + 1) <>
    identifier(subroutineName, level + 1) <>
    symbol("(", level + 1) <>
    ParameterList.compile([%{start: true} | left_over_tokens], level + 1, stack)
  end
end
