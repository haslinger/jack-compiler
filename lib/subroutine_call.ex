defmodule SubroutineCall do
  import Helpers

  # end of statement
  def compile([%{symbol: :";"} | _] = tokens, level) do
    IO.puts("... SubroutineCall 1")
    DoStatement.compile(tokens, level)
  end

  def compile([%{symbol: :")"} | left_over_tokens], level) do
    IO.puts("... SubroutineCall 2")
    symbol(")", level) <>
    compile(left_over_tokens, level)
  end

  def compile([%{identifier: subroutineName},
               %{symbol: :"("} | left_over_tokens], level) do
    IO.puts("... SubroutineCall 3")
    identifier(subroutineName, level) <>
    symbol("(", level) <>
    ExpressionList.compile([%{start: true} | left_over_tokens], level)
  end

  def compile([%{identifier: classOrVarName},
               %{symbol: :"."},
               %{identifier: subroutineName},
               %{symbol: :"("} | left_over_tokens], level) do
    IO.puts("... SubroutineCall 4")
    identifier(classOrVarName, level) <>
    symbol(".", level) <>
    identifier(subroutineName, level) <>
    symbol("(", level) <>
    ExpressionList.compile([%{start: true} | left_over_tokens], level)
  end
end
