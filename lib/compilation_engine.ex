defmodule CompilationEngine do

  def compile(%{tokens: tokens}) do
    IO.puts("... CompilationEngine 1")
    Class.compile(tokens, 2)
  end
end
