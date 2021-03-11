defmodule ClassBody do

  def compile([%{symbol: :"}"} | _] = tokens, level, stack) do
    Class.compile(tokens, level, stack);
  end

  ## classVarDec: ("static" | "field" )
  def compile([%{keyword: keyword} | _] = tokens, level, stack)
  when keyword in [:static, :field] do
    ClassVarDec.compile(tokens, level, stack)
  end

  ## subroutineDec: ("constructor", "function", "method")
  def compile([%{keyword: keyword} | _] = tokens, level, stack)
  when keyword in [:constructor, :function, :method] do
    SubroutineDec.compile(tokens, level, stack)
  end
end
