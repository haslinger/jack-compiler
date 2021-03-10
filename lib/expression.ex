defmodule Expression do
  import Helpers

  # end of statement
  def compile([%{symbol: symbol} | _] = tokens, level, [callback | stack])
  when symbol in [:")", :";", :"]", :","] do
    IO.puts("... Expression 1")
    indent(level - 1) <> "</expression>\n"<>
    callback.(tokens, level - 1, stack)
  end

  def compile(tokens, level, stack) do
    IO.puts("... Expression 2")
    indent(level) <> "<expression>\n"<>
    Term.compile(tokens, level + 1, stack)
  end
end
