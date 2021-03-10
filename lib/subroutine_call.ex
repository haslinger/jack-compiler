defmodule SubroutineCall do
  import Helpers

  # end of statement
  def compile([%{symbol: :";"} | _ ] = tokens, level) do
    IO.puts("... SubroutineCall 1")
    symbol(";", level) <>
    indent(level - 1) <> "</doStatement>\n"<>
    DoStatement.compile(tokens, level)
  end

  def compile(%{symbol: :")"} | left_over_tokens], level) do
    #FIXME!
  end

  def compile([%{identifier: subroutineName},
               %{symbol: :"("},
               %{symbol: :")"} | left_over_tokens], level) do
    IO.puts("... SubroutineCall 3")
    identifier(subroutineName, level) <>
    symbol("(", level) <>
    ExpressionList.compile(left_over_tokens, level, callback: &SubroutineCall.compile/2)
  end


  def compile([%{identifier: subroutineName},
               %{symbol: :"."},
               %{identifier: secondSubroutineName},
               %{symbol: :"("},
               %{symbol: :")"} | left_over_tokens], level) do
    IO.puts("... SubroutineCall 2")
    keyword(:do, level) <>
    identifier(subroutineName, level) <>
    symbol(".", level) <>
    identifier(secondSubroutineName, level) <>
    symbol("(", level) <>
    indent(level) <> "<expressionList>\n"<>
    indent(level) <> "</expressionList>\n"<>
    symbol(")", level) <>
    compile(left_over_tokens, level)
  end
end
