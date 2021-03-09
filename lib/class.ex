defmodule Class do
  import Helpers

  ## class: "class" className "{"  classVarDec* subroutineDec* "}"
  def compile([%{keyword: :class},
               %{identifier: className},
               %{symbol: :"{"} | left_over_tokens], level) do
    IO.puts("... Class 1")
    indent(level) <> "<class>\n" <>
    keyword(:class, level + 1) <>
    identifier(className, level + 1) <>
    symbol("{", level + 1) <>
    ClassBody.compile(left_over_tokens, level + 1)
  end

  def compile([%{symbol: :"}"}], level) do
    IO.puts("... Class 2")
    symbol("}", level) <>
    indent(level - 1) <> "</class>\n"
  end
end
