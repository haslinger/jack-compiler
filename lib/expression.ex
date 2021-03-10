defmodule Expression do
  import Helpers

  # end of statement
  def compile([%{symbol: symbol} | _] = tokens, level, [callback | stack])
  when symbol in [:")", :";", :"]", :","] do
    IO.puts("... Expression 1")
    indent(level - 1) <> "</expression>\n"<>
    callback.(tokens, level - 1, stack)
  end

  def compile([%{symbol: operator} | left_over_tokens], level, stack)
  when operator in [:"+", :"-", :"*", :"/", :"&", :"|", :"<", :">", :"="] do
    IO.puts("... Expression 2")
    symbol(Atom.to_string(operator), level) <>
    Term.compile(left_over_tokens, level, [&Expression.compile/3 | stack])
  end


  def compile(tokens, level, stack) do
    IO.puts("... Expression 3")
    indent(level) <> "<expression>\n"<>
    Term.compile(tokens, level + 1, [&Expression.compile/3 | stack])
  end
end
