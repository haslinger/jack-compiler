defmodule CompilationEngine do

  def compile(%{tokens: tokens}) do
    stack = []
    Class.compile(tokens, 0, stack)
  end
end
