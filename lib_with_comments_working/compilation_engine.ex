defmodule CompilationEngine do

  def compile(%{tokens: tokens}) do
    stack = []
    IO.puts("... CompilationEngine 1")
    Class.compile(tokens, 0, stack)
  end
end
