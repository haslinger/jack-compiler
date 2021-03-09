defmodule CompilationEngine do
  def compile(%{tokens: tokens}) do
    IO.puts("=== A ===")
    compileClass(tokens, 0)
  end

  ## class: "class" className "{"  classVarDec* subroutineDec* "}"
  def compileClass([%{keyword: :class},
                    %{identifier: className},
                    %{symbol: :"{"} | left_over_tokens], level) do
    IO.puts("=== B ===")
    indent(level) <> "<class>\n" <>
    identifier(className, level + 1) <>
    symbol("{", level + 1) <>
    compileClassDec(left_over_tokens, level)
  end

  def compileClass([%{symbol: :"}"}], level) do
    IO.puts("=== C ===")
    symbol("}", level + 1) <>
    indent(level) <> "</class>\n"
  end

  ## classVarDec: ("static" | "field" )
  def compileClassDec([%{keyword: keyword} | left_over_tokens], level)
  when keyword in [:static, :field] do
    IO.puts("=== D ===")
    indent(level) <> "<classVarDec>\n" <>
    keyword(keyword, level + 1) <>
    compileClassVarDec(left_over_tokens, level + 1)
  end

  ## subroutineDec: ("constructor", "function", "method")
  def compileClassDec([%{keyword: keyword} | left_over_tokens], level)
  when keyword in [:constructor, :function, :method] do
    IO.puts("=== E ===")
    indent(level) <> "<subroutineDec>\n" <>
    keyword(keyword, level + 1) <>
    compileSubroutineDec(left_over_tokens, level + 1)
  end

  def compileClassDec([%{symbol: :"{"} | _] = tokens, level) do
    IO.puts("=== F ===")
    compileSubroutineBody(tokens, level);
  end

  # type :int | :char | :boolean varName
  def compileClassVarDec([%{keyword: keyword},
                          %{identifier: varname} | left_over_tokens], level)
  when keyword in [:int, :char, :boolean] do
    IO.puts("=== G ===")
    keyword(keyword, level) <>
    identifier(varname, level) <>
    compileClassVarDec(left_over_tokens, level)
  end

  # type className varName
  def compileClassVarDec([%{identifier: className},
                          %{identifier: varName} | left_over_tokens], level) do
    IO.puts("=== H ===")
    identifier(className, level) <>
    identifier(varName, level) <>
    compileClassVarDec(left_over_tokens, level)
  end

  # ,varName *
  def compileClassVarDec([%{symbol: :","},
                          %{identifier: varName} | left_over_tokens], level) do
    IO.puts("=== I ===")
    identifier(varName, level) <>
    compileClassVarDec(left_over_tokens, level)
  end

  # ;
  def compileClassVarDec([%{symbol: :";"} | left_over_tokens], level) do
    IO.puts("=== J ===")
    indent(level - 1) <> "</classVarDec>\n" <>
    compileClassDec(left_over_tokens, level);
  end

  # (:void | :int | :char | :boolean) subroutineName "("
  def compileSubroutineDec([%{keyword: keyword},
                            %{identifier: subroutineName},
                            %{symbol: :"("} | left_over_tokens], level)
  when keyword in [:void, :int, :char, :boolean] do
    IO.puts("=== K ===")
    keyword(keyword, level) <>
    identifier(subroutineName, level) <>
    symbol("(", level) <>
    indent(level) <> "<parameterList>\n" <>
    compileSubroutineDec(left_over_tokens, level)
  end

  # className subroutineName "("
  def compileSubroutineDec([%{identifier: className},
                            %{identifier: subroutineName},
                            %{symbol: :"("} | left_over_tokens], level) do
    IO.puts("=== L ===")
    identifier(className, level) <>
    identifier(subroutineName, level) <>
    symbol("(", level) <>
    indent(level) <> "<parameterList>\n" <>
    compileParameterList(left_over_tokens, level + 1)
  end

  def compileSubroutineDec([%{symbol: :")"} | left_over_tokens], level) do
    IO.puts("=== M ===")
    symbol(")", level) <>
    indent(level - 1) <> "</subroutineDec>\n" <>
    compileClassDec(left_over_tokens, level - 1)
  end

  # type :void | :int | :char varName
  def compileParameterList([%{keyword: keyword},
                            %{identifier: varName} | left_over_tokens], level)
  when keyword in [:int, :char, :boolean] do
    IO.puts("=== N ===")
    keyword(keyword, level) <>
    identifier(varName, level) <>
    compileParameterList(left_over_tokens, level)
  end

  #  type className varName
  def compileParameterList([%{identifier: className},
                            %{identifier: varName} | left_over_tokens], level) do
    IO.puts("=== O ===")
    identifier(className, level) <>
    identifier(varName, level) <>
    compileParameterList(left_over_tokens, level)
  end

  #  "," type :void | :int | :char varName
  def compileParameterList([%{symbol: :","},
                            %{keyword: keyword},
                            %{identifier: varName} | left_over_tokens], level)
  when keyword in [:int, :char, :boolean] do
    IO.puts("=== P ===")
    symbol(",", level) <>
    keyword(keyword, level) <>
    identifier(varName, level) <>
    compileParameterList(left_over_tokens, level)
  end

  #  "," type className varName
  def compileParameterList([%{symbol: :","},
                            %{identifier: className},
                            %{identifier: varName} | left_over_tokens], level) do
    IO.puts("=== Q ===")
    symbol(",", level) <>
    identifier(className, level) <>
    identifier(varName, level) <>
    compileParameterList(left_over_tokens, level)
  end

  # ")"
  def compileParameterList([%{symbol: :")"} | left_over_tokens], level) do
    IO.puts("=== R ===")
    symbol(")", level) <>
    indent(level) <> "</parameterList>\n" <>
    compileSubroutineBody(left_over_tokens, level - 1)
  end

  # subroutineBody: "{" varDec* statements "}"
  def compileSubroutineBody([%{symbol: :"{"} | left_over_tokens], level) do
    IO.puts("=== S ===")
    indent(level) <> "<subroutineBody>\n" <>
    symbol("{", level + 1) <>
    compileSubroutineBody(left_over_tokens, level + 1)
  end

  # "var" type :void | :int | :char varName
  def compileSubroutineBody([%{keyword: :var},
                             %{keyword: keyword},
                             %{identifier: varName} | left_over_tokens], level)
  when keyword in [:int, :char, :boolean]  do
    IO.puts("=== T ===")
    keyword(:varDec, level) <>
    keyword(:var, level + 1) <>
    keyword(keyword, level + 1) <>
    identifier(keyword, varName + 1) <>
    compileVariableDeclaration(left_over_tokens, level + 1)
  end

  def compileSubroutineBody([%{symbol: :"}"} | left_over_tokens], level) do
    symbol("}", level) <>
    indent(level- 1) <> "</subroutineBody>\n" <>
    compileSubroutineDec(left_over_tokens, level - 1)
  end


  # "var" type className varName
  def compileSubroutineBody([%{keyword: :var},
                             %{identifier: className},
                             %{identifier: varName} | left_over_tokens], level) do
    IO.puts("=== U ===")
    indent(level) <> "<varDec>\n" <>
    keyword(:var, level + 1) <>
    identifier(className, level + 1) <>
    identifier(varName, level + 1) <>
    compileVariableDeclaration(left_over_tokens, level + 1)
  end

  def compileSubroutineBody(tokens, level) do
    IO.puts("=== V ===")
    keyword(:statements, level) <>
    indent(level) <> "<statements>\n"<>
    compileStatements(tokens, level + 1)
  end

  # ("," varName)*
  def compileVariableDeclaration([%{symbol: :","},
                                  %{identifier: varName} | left_over_tokens], level) do
    IO.puts("=== W ===")
    symbol(",", level) <>
    identifier(varName, level) <>
    compileVariableDeclaration(left_over_tokens, level)
  end

  #";"
  def compileVariableDeclaration([%{symbol: :";"} | left_over_tokens], level) do
    IO.puts("=== X ===")
    symbol(";", level) <>
    indent(level- 1) <> "</varDec>\n" <>
    compileSubroutineBody(left_over_tokens, level - 1)
  end

  def compileStatements([%{keyword: :let} | left_over_tokens ], level) do
    IO.puts("=== S1 ===")
    indent(level) <> "<letStatement>\n" <>
    compileLetStatement(left_over_tokens, level + 1)
  end

  #FIXME! more compileStatements

  def compileStatements([%{symbol: :"}"} | left_over_tokens ], level) do
    IO.puts("=== Y ===")
    indent(level) <> "</statements>\n"<>
    compileSubroutineBody(left_over_tokens, level - 1)
  end

  def compileLetStatement([%{symbol: :";"} | left_over_tokens ], level) do
    symbol(";", level) <>
    indent(level - 1) <> "</letStatement>\n"<>
    compileStatements(left_over_tokens, level - 1)
  end

  def compileLetStatement([%{identifier: varName},
                           %{symbol: :"="} | left_over_tokens], level) do
    keyword(:let, level) <>
    identifier(varName, level) <>
    symbol("=", level) <>
    indent(level + 1) <> "<term>\n"<>
    compileTerm(left_over_tokens, level + 1, callback: &compileLetStatement/2)
  end

  def compileTerm([%{identifier: identifier} | left_over_tokens], level, callback: callback) do
    identifier(identifier, level) <>
    compileTerm(left_over_tokens, level - 1, callback: callback)
  end

  def compileTerm([%{symbol: :";"} | _ ] = tokens, level, callback: callback) do
    indent(level) <> "</term>\n"<>
    callback.(tokens, level - 1)
  end

  #!FIXME more expressions to be inserted here

  def indent(level) do
    indent_by_spaces = 2
    String.duplicate(" ", level * indent_by_spaces)
  end

  def keyword(value, level), do: terminal(:keyword, Atom.to_string(value), level)
  def identifier(value, level), do: terminal(:identifier, value, level)
  def symbol(value, level), do: terminal(:symbol, value, level)

  def terminal(tag, value, level) do
    indent(level) <> #indentation
    "<" <> Atom.to_string(tag) <> "> " <> # Opening Tag
    value <> # Value
    " </" <> Atom.to_string(tag) <> ">\n" # Closing Tag + Newline
  end
end
