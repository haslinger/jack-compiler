defmodule SubroutineBody do
  import Helpers

  # subroutineBody: "{" varDec* statements "}"
  def compile([%{symbol: :"{"} | left_over_tokens], level, stack) do
    IO.puts("... SubroutineBody 1")
    indent(level) <> "<subroutineBody>\n" <>
    symbol("{", level + 1) <>
    compile(left_over_tokens, level + 1, stack)
  end

  def compile([%{symbol: :"}"} | _] = tokens, level, stack) do
    IO.puts("... SubroutineBody 2")
    symbol("}", level) <>
    indent(level - 1) <> "</subroutineBody>\n" <>
    SubroutineDec.compile(tokens, level - 1, stack)
  end

  # "var" type :void | :int | :char varName
  def compile([%{keyword: :var},
               %{keyword: keyword},
               %{identifier: varName} | left_over_tokens], level, stack)
  when keyword in [:int, :char, :boolean]  do
    IO.puts("... SubroutineBody 3")
    indent(level) <> "<varDec>\n" <>
    keyword(:var, level + 1) <>
    keyword(keyword, level + 1) <>
    identifier(varName, level + 1) <>
    VariableDeclaration.compile(left_over_tokens, level + 1, stack)
  end

  # "var" type className varName
  def compile([%{keyword: :var},
               %{identifier: className},
               %{identifier: varName} | left_over_tokens], level, stack) do
    IO.puts("... SubroutineBody 4")
    indent(level) <> "<varDec>\n" <>
    keyword(:var, level + 1) <>
    identifier(className, level + 1) <>
    identifier(varName, level + 1) <>
    VariableDeclaration.compile(left_over_tokens, level + 1, stack)
  end

  def compile(tokens, level, stack) do
    IO.puts("... SubroutineBody 5")
    Statements.compile(tokens, level, [&SubroutineBody.compile/3 | stack])
  end
end
