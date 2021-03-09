defmodule ClassBody do
  import Helpers

  ## classVarDec: ("static" | "field" )
  def compile([%{keyword: keyword} | left_over_tokens], level)
  when keyword in [:static, :field] do
    IO.puts("... ClassDec 1")
    indent(level) <> "<classVarDec>\n" <>
    keyword(keyword, level + 1) <>
    ClassVarDec.compile(left_over_tokens, level + 1)
  end

  ## subroutineDec: ("constructor", "function", "method")
  def compile([%{keyword: keyword} | left_over_tokens], level)
  when keyword in [:constructor, :function, :method] do
    IO.puts("... ClassDec 2")
    indent(level) <> "<subroutineDec>\n" <>
    keyword(keyword, level + 1) <>
    SubroutineDec.compile(left_over_tokens, level + 1)
  end

  def compile([%{symbol: :"}"} | _] = tokens, level) do
    IO.puts("... SubroutineDec 4")
    indent(level - 1) <> "</subroutineDec>\n" <>
    Class.compile(tokens, level - 1);
  end
end
