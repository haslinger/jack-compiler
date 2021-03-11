defmodule Term do
  import Helpers

  def compile([%{symbol: symbol} | _] = tokens, level, [callback | stack])
  when symbol in [:";", :",", :")", :"]"] do
    indent(level - 1) <> "</term>\n"<>
    callback.(tokens, level - 1, stack)
  end

  def compile([%{symbol: operator} | _] = tokens, level, [callback | stack])
  when operator in [:"+", :"-", :"*", :"/", :"&", :"|", :"<", :">", :"="] do
    indent(level - 1) <> "</term>\n"<>
    callback.(tokens, level - 1, stack)
  end

  def compile([%{integer: integerConstant} | left_over_tokens], level, stack) do
    indent(level) <> "<term>\n"<>
    integer(integerConstant, level + 1) <>
    compile(left_over_tokens, level + 1, stack)
  end

  def compile([%{string: stringConstant} | left_over_tokens], level, stack) do
    indent(level) <> "<term>\n"<>
    string(stringConstant, level + 1) <>
    compile(left_over_tokens, level + 1, stack)
  end

  def compile([%{keyword: keywordConstant} | left_over_tokens], level, stack) do
    indent(level) <> "<term>\n"<>
    keyword(keywordConstant, level + 1) <>
    compile(left_over_tokens, level + 1, stack)
  end

  def compile([%{symbol: operator} | left_over_tokens], level, stack)
  when operator in [:"-", :"~"] do
    indent(level) <> "<term>\n"<>
    symbol(Atom.to_string(operator), level + 1) <>
    Term.compile(left_over_tokens, level + 1, [&Term.compile/3 | stack])
  end

  def compile([%{symbol: :"("} | left_over_tokens], level, stack) do
    indent(level) <> "<term>\n"<>
    symbol("(", level + 1) <>
    Expression.compile(left_over_tokens, level + 1, [&Term.capture_parens/3 | stack])
  end

  def compile([%{identifier: varName}, %{symbol: :"["} | left_over_tokens], level, stack) do
    indent(level) <> "<term>\n"<>
    identifier(varName, level + 1) <>
    symbol("[", level + 1) <>
    Expression.compile(left_over_tokens, level + 1, [&Term.capture_parens/3 | stack])
  end

  def compile([%{identifier: _}, %{symbol: symbol} | _] = tokens, level, stack)
  when symbol in [:"(", :"."] do
    indent(level) <> "<term>\n"<>
    SubroutineCall.compile(tokens, level + 1, [&Term.compile/3 | stack])
  end

  def compile([%{identifier: varName} | left_over_tokens], level, stack) do
    indent(level) <> "<term>\n"<>
    identifier(varName, level + 1) <>
    compile(left_over_tokens, level + 1, stack)
  end

  def capture_parens([%{symbol: parens} | left_over_tokens], level, stack)
  when parens in [:")", :"]"] do
    symbol(Atom.to_string(parens), level) <>
    compile(left_over_tokens, level, stack)
  end
end
