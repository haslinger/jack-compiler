defmodule Statements do
  import Helpers

  # end of statements
  def compile(tokens, level, stack) do
    IO.puts("... Statements 1")
    indent(level) <> "<statements>\n" <>
    shadowed(tokens, level + 1, stack)
  end

  # statements can come in multiple, the block should be encapsulated, recalls not any more
  def shadowed([%{symbol: :"}"} | _] = tokens, level, [callback | stack]) do
    IO.puts("... Statements 2")
    indent(level - 1) <> "</statements>\n" <>
    callback.(tokens, level - 1, stack)
  end

  def shadowed([%{keyword: :let} | _] = tokens, level, stack) do
    IO.puts("... Statements 3")
    LetStatement.compile(tokens, level, [&Statements.shadowed/3 | stack])
  end

  def shadowed([%{keyword: :do} | _] = tokens, level, stack) do
    IO.puts("... Statements 4")
    DoStatement.compile(tokens, level, [&Statements.shadowed/3 | stack])
  end

  def shadowed([%{keyword: :return} | _] = tokens, level, stack) do
    IO.puts("... Statements 5")
    ReturnStatement.compile(tokens, level, [&Statements.shadowed/3 | stack])
  end

  def shadowed([%{keyword: :if} | _] = tokens, level, stack) do
    IO.puts("... Statements 6")
    IfStatement.compile(tokens, level, [&Statements.shadowed/3 | stack])
  end

  def shadowed([%{keyword: :while} | _] = tokens, level, stack) do
    IO.puts("... Statements 7")
    WhileStatement.compile(tokens, level, [&Statements.shadowed/3 | stack])
  end
end
