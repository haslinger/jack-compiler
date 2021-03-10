defmodule Statements do
  import Helpers

  # end of statements
  def compile([%{symbol: :"}"} | _] = tokens, level) do
    IO.puts("... Statements 1")
    indent(level - 1) <> "</statements>\n" <>
    SubroutineBody.compile(tokens, level - 1)
  end

  def compile([%{keyword: :let} | _] = tokens, level) do
    IO.puts("... Statements 2")
    LetStatement.compile(tokens, level)
  end

  def compile([%{keyword: :do} | _] = tokens, level) do
    IO.puts("... Statements 3")
    DoStatement.compile(tokens, level)
  end

  def compile([%{keyword: :return} | _] = tokens, level) do
    IO.puts("... Statements 4")
    ReturnStatement.compile(tokens, level)
  end
end
