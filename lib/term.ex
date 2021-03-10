defmodule Term do
  import Helpers

  def compile([%{symbol: symbol} | _] = tokens, level, [callback |stack])
  when symbol in [:")", :";", :",", :"]"] do
    IO.puts("... Term 1")
    indent(level - 1) <> "</term>\n"<>
    callback.(tokens, level - 1, stack)
  end

  def compile([%{integer: integerConstant} | left_over_tokens], level, stack) do
    IO.puts("... Term 2")
    indent(level) <> "<term>\n"<>
    integer(integerConstant, level + 1) <>
    compile(left_over_tokens, level + 1, stack)
  end

  def compile([%{string: stringConstant} | left_over_tokens], level, stack) do
    IO.puts("... Term 3")
    indent(level) <> "<term>\n"<>
    string(stringConstant, level + 1) <>
    compile(left_over_tokens, level + 1, stack)
  end

  def compile([%{keyword: keywordConstant} | left_over_tokens], level, stack) do
    IO.puts("... Term 4")
    indent(level) <> "<term>\n"<>
    keyword(keywordConstant, level + 1) <>
    compile(left_over_tokens, level + 1, stack)
  end

  def compile([%{symbol: operator} | left_over_tokens], level, stack)
  when operator in [:"-", :"~"] do
    IO.puts("... Term 5")
    indent(level) <> "<term>\n"<>
    symbol(Atom.to_string(operator), level + 1) <>
    Term.compile(left_over_tokens, level + 1, [&Term.compile/3 | stack])
  end

  def compile([%{symbol: :"("} | left_over_tokens], level, stack) do
    IO.puts("... Term 6")
    indent(level) <> "<term>\n"<>
    symbol("(", level + 1) <>
    Expression.compile(left_over_tokens, level + 1, [&Term.compile/3 | stack])
  end

  def compile([%{symbol: symbol} | left_over_tokens], level, stack)
  when symbol in [:"]", :")"] do
    IO.puts("... Term 7")
    symbol(Atom.to_string(symbol), level) <>
    compile(left_over_tokens, level, stack)
  end

  def compile([%{identifier: varName}, %{symbol: :"["} | left_over_tokens], level, stack) do
    IO.puts("... Term 8")
    indent(level) <> "<term>\n"<>
    identifier(varName, level) <>
    symbol("[", level + 1) <>
    Expression.compile(left_over_tokens, level + 1, [&Term.compile/3 | stack])
  end

  def compile([%{identifier: _}, %{symbol: symbol} | _] = tokens, level, stack)
  when symbol in [:"(", :"."] do
    IO.puts("... Term 9")
    indent(level) <> "<term>\n"<>
    SubroutineCall.compile(tokens, level + 1, [&Term.compile/3 | stack])
  end

  def compile([%{identifier: varName} | left_over_tokens], level, stack) do
    IO.puts("... Term 10")
    indent(level) <> "<term>\n"<>
    identifier(varName, level) <>
    compile(left_over_tokens, level + 1, stack)
  end
end
