defmodule Statements do
  import Helpers

  # end of statements
  def compile(tokens, level, stack) do
    indent(level) <> "<statements>\n" <>
    shadowed(tokens, level + 1, stack)
  end

  # statements can come in multiple, the block should be encapsulated, recalls not any more
  def shadowed([%{symbol: :"}"} | _] = tokens, level, [callback | stack]) do
    indent(level - 1) <> "</statements>\n" <>
    callback.(tokens, level - 1, stack)
  end

  def shadowed([%{keyword: :let} | _] = tokens, level, stack) do
    LetStatement.compile(tokens, level, [&Statements.shadowed/3 | stack])
  end

  def shadowed([%{keyword: :do} | _] = tokens, level, stack) do
    DoStatement.compile(tokens, level, [&Statements.shadowed/3 | stack])
  end

  def shadowed([%{keyword: :return} | _] = tokens, level, stack) do
    ReturnStatement.compile(tokens, level, [&Statements.shadowed/3 | stack])
  end

  def shadowed([%{keyword: :if} | _] = tokens, level, stack) do
    IfStatement.compile(tokens, level, [&Statements.shadowed/3 | stack])
  end

  def shadowed([%{keyword: :while} | _] = tokens, level, stack) do
    WhileStatement.compile(tokens, level, [&Statements.shadowed/3 | stack])
  end
end
