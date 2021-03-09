defmodule SubroutineDec do
  import Helpers

  # (:void | :int | :char | :boolean) subroutineName "("
  def compile([%{keyword: keyword},
               %{identifier: subroutineName},
               %{symbol: :"("} | left_over_tokens], level)
  when keyword in [:void, :int, :char, :boolean] do
    IO.puts("... SubroutineDec 1")
    keyword(keyword, level) <>
    identifier(subroutineName, level) <>
    symbol("(", level) <>
    indent(level) <> "<parameterList>\n" <>
    ParameterList.compile(left_over_tokens, level)
  end

  # className subroutineName "("
  def compile([%{identifier: className},
               %{identifier: subroutineName},
               %{symbol: :"("} | left_over_tokens], level) do
    IO.puts("... SubroutineDec 2")
    identifier(className, level) <>
    identifier(subroutineName, level) <>
    symbol("(", level) <>
    indent(level) <> "<parameterList>\n" <>
    ParameterList.compile(left_over_tokens, level + 1)
  end

  def compile([%{symbol: :")"} | left_over_tokens], level) do
    IO.puts("... SubroutineDec 3")
    symbol(")", level) <>
    SubroutineBody.compile(left_over_tokens, level)
  end

  def compile([%{symbol: :"}"} | _] = tokens, level) do
    IO.puts("... SubroutineDec 4")
    ClassBody.compile(tokens, level - 1);
  end
end
