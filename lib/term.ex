defmodule Term do
  import Helpers

  def compile([%{symbol: symbol} | _] = tokens, level, stack)
  when symbol in [:")", :";", :","] do
    IO.puts("... Term 1")
    indent(level - 1) <> "</term>\n"<>
    Expression.compile(tokens, level - 1, stack)
  end

  def compile([%{identifier: identifier} | left_over_tokens], level, stack) do
    IO.puts("... Term 2")
    indent(level) <> "<term>\n"<>
    identifier(identifier, level + 1) <>
    compile(left_over_tokens, level + 1, stack)
  end
end
