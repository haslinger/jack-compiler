defmodule Class do
  import Helpers

  ## class: "class" className "{"  classVarDec* subroutineDec* "}"
  def compile([%{keyword: :class},
               %{identifier: className},
               %{symbol: :"{"} | left_over_tokens], level, stack) do
    indent(level) <> "<class>\n" <>
    keyword(:class, level + 1) <>
    identifier(className, level + 1) <>
    symbol("{", level + 1) <>
    ClassBody.compile(left_over_tokens, level + 1, stack)
  end

  def compile([%{symbol: :"}"}], level, _stack) do
    symbol("}", level) <>
    indent(level - 1) <> "</class>\n"
  end
end
