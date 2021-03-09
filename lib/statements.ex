defmodule Statements do
  import Helpers

  def compile([%{keyword: :let} | left_over_tokens ], level) do
    IO.puts("=== Statements 1 ===")
    indent(level) <> "<letStatement>\n" <>
    LetStatement.compile(left_over_tokens, level + 1)
  end

  # end of statements
  def compile([%{symbol: :"}"} | left_over_tokens ], level) do
    IO.puts("=== Statements 2 ===")
    indent(level) <> "</statements>\n"<>
    SubroutineBody.compile(left_over_tokens, level - 1)
  end
end
