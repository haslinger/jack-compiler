defmodule DoStatement do
  import Helpers

  # end of statement
  def compile([%{symbol: :";"} | left_over_tokens ], level) do
    IO.puts("... DoStatement 1")
    symbol(";", level) <>
    indent(level - 1) <> "</doStatement>\n"<>
    Statements.compile(left_over_tokens, level - 1)
  end

  def compile([%{identifier: subroutineName},
               %{symbol: :"."},
               %{identifier: secondSubroutineName},
               %{symbol: :"("},
               %{symbol: :")"} | left_over_tokens], level) do
    IO.puts("... DoStatement 2")
    keyword(:do, level) <>
    identifier(subroutineName, level) <>
    symbol(".", level) <>
    identifier(secondSubroutineName, level) <>
    symbol("(", level) <>
    indent(level) <> "<exressionList>\n"<>
    indent(level) <> "</exressionList>\n"<>
    symbol(")", level) <>
    compile(left_over_tokens, level)
  end

  def compile([%{identifier: subroutineName},
               %{symbol: :"("},
               %{symbol: :")"} | left_over_tokens], level) do
    IO.puts("... DoStatement 3")
    keyword(:do, level) <>
    identifier(subroutineName, level) <>
    symbol("(", level) <>
    indent(level) <> "<exressionList>\n"<>
    indent(level) <> "</exressionList>\n"<>
    symbol(")", level) <>
    compile(left_over_tokens, level)
  end
end
