defmodule Statements do
  import Helpers

  def compile([%{keyword: :let} | left_over_tokens ], level) do
    IO.puts("... Statements 1")
    indent(level) <> "<letStatement>\n" <>
    LetStatement.compile(left_over_tokens, level + 1)
  end

  def compile([%{keyword: :do} | left_over_tokens ], level) do
    IO.puts("... Statements 2")
    indent(level) <> "<doStatement>\n" <>
    DoStatement.compile(left_over_tokens, level + 1)
  end

  def compile([%{keyword: :return} | _] = tokens, level) do
    IO.puts("... Statements 3")
    indent(level) <> "<returnStatement>\n" <>
    ReturnStatement.compile(tokens, level + 1)
  end

  # end of statements
  def compile([%{symbol: :"}"} | _ ] = tokens, level) do
    IO.puts("... Statements 4")
    indent(level) <> "</statements>\n" <>
    SubroutineBody.compile(tokens, level - 1)
  end
end
