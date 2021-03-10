defmodule Statements do
  import Helpers

  # end of statements
  def compile([%{symbol: :"}"} | _] = tokens, level, [ callback | stack]) do
    IO.puts("... Statements 1")
    indent(level - 1) <> "</statements>\n" <>
    callback.(tokens, level - 1, stack)
  end

  def compile([%{keyword: :let} | _] = tokens, level, stack) do
    IO.puts("... Statements 2")
    LetStatement.compile(tokens, level, stack)
  end

  def compile([%{keyword: :do} | _] = tokens, level, stack) do
    IO.puts("... Statements 3")
    DoStatement.compile(tokens, level, stack)
  end

  def compile([%{keyword: :return} | _] = tokens, level, stack) do
    IO.puts("... Statements 4")
    ReturnStatement.compile(tokens, level, stack)
  end

  def compile([%{keyword: :if} | _] = tokens, level, stack) do
    IO.puts("... Statements 5")
    If.compile(tokens, level, stack)
  end
end
