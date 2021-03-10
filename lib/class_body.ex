defmodule ClassBody do

  def compile([%{symbol: :"}"} | _] = tokens, level, stack) do
    IO.puts("... SubroutineDec 4")
    Class.compile(tokens, level, stack);
  end

  ## classVarDec: ("static" | "field" )
  def compile([%{keyword: keyword} | _] = tokens, level, stack)
  when keyword in [:static, :field] do
    IO.puts("... ClassDec 1")
    ClassVarDec.compile(tokens, level, stack)
  end

  ## subroutineDec: ("constructor", "function", "method")
  def compile([%{keyword: keyword} | _] = tokens, level, stack)
  when keyword in [:constructor, :function, :method] do
    IO.puts("... ClassDec 2")
    SubroutineDec.compile(tokens, level, stack)
  end
end
