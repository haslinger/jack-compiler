defmodule Class do
  import Helpers

  ## class: "class" className "{"  classVarDec* subroutineDec* "}"
  def compile([%{keyword: :class},
               %{identifier: className},
               %{symbol: :"{"} | left_over_tokens], level) do
    IO.puts("=== Class 1 ===")
    indent(level) <> "<class>\n" <>
    identifier(className, level + 1) <>
    symbol("{", level + 1) <>
    ClassDec.compile(left_over_tokens, level)
  end

  def compile([%{symbol: :"}"}], level) do
    IO.puts("=== Class 2 ===")
    symbol("}", level + 1) <>
    indent(level) <> "</class>\n"
  end
end
