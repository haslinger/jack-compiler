defmodule Term do
  import Helpers

  def compile([%{identifier: identifier} | left_over_tokens], level, callback: callback) do
    IO.puts("... Term 1")
    identifier(identifier, level) <>
    compile(left_over_tokens, level - 1, callback: callback)
  end

  def compile([%{symbol: :";"} | _ ] = tokens, level, callback: callback) do
    IO.puts("... Term 2")
    indent(level - 1) <> "</term>\n"<>
    Expression.compile(tokens, level - 1, callback: callback)
  end
end