defmodule Expression do
  import Helpers

  # end of statement
  def compile([%{symbol: :")"} | _ ] = tokens, level, callback: callback) do
    IO.puts("... Expression 1")
    indent(level - 1) <> "</expression>\n"<>
    callback.(tokens, level - 1)
  end

  def compile([%{symbol: :";"} | _ ] = tokens, level, callback: callback) do
    IO.puts("... Expression 2")
    indent(level - 1) <> "</expression>\n"<>
    callback.(tokens, level - 1)
  end

  def compile([token], level, callback: callback) do
    IO.puts("... Expression 3")
    Term.compile(left_over_tokens, level + 2, callback: callback)
  end
end
