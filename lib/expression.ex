defmodule Expression do
  import Helpers

  # end of statement
  def compile([%{identifier: identifier} | left_over_tokens], level, callback: callback) do
    IO.puts("... Expression 1")
    indent(level + 1) <> "<term>\n"<>
    identifier(identifier, level + 2) <>
    Term.compile(left_over_tokens, level + 2, callback: callback)
  end

  def compile([%{symbol: :";"} | _ ] = tokens, level, callback: callback) do
    IO.puts("... Expression 2")
    indent(level - 1) <> "</expression>\n"<>
    callback.(tokens, level - 1)
  end
end
