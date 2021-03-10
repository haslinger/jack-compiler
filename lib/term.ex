defmodule Term do
  import Helpers

  def compile([%{symbol: :")"} | _] = tokens, level, callback: callback) do
    IO.puts("... Term 1")
    indent(level) <> "</term>\n"<>
    Expression.compile(tokens, level - 1, callback: callback)
  end

  def compile([%{symbol: :";"} | _] = tokens, level, callback: callback) do
    IO.puts("... Term 2")
    indent(level - 1) <> "</term>\n"<>
    Expression.compile(tokens, level - 1, callback: callback)
  end

  def compile([%{identifier: identifier} | left_over_tokens], level, callback: callback) do
    IO.puts("... Term 3")
    indent(level) <> "<term>\n"<>
    identifier(identifier, level + 1) <>
    compile(left_over_tokens, level + 1, callback: callback)
  end
end
