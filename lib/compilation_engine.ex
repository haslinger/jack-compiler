defmodule FlatCompilationEngine do
  def compile(%{tokens: tokens}) do
    compileClass(tokens, 0)
  end

  ## class: 'class' className '{'  classVarDec* subroutineDec* '}'
  def compileClass(
    [%{tokenType: :keyword, keyword: :class},
    %{tokenType: :identifier, keyword: className},
    %{tokenType: :symbol, symbol: '{'},
    | left_over_tokens], level)
  when is_list(tokens) do

    indent(level) <> '<class>\n' <>
    keyword('class', level + 1) <>
    identifier(className, level + 1) <>
    symbol('{', level + 1) <>
    compileClassDec(tokens, level)
  end

  def compileClass(%{tokenType: :symbol, symbol: '}', level} do
    symbol('}', level + 1) <>
    indent(level) <> '</class>\n'
  end

  ## classVarDec: ('static' | 'field' )
  def compileClassDec(
    [%{tokenType: :keyword, keyword: keyword}
    | left_over_tokens ], level)
  when keyword in [:static, :field] do
      indent(level) <> '<classVarDec>\n' <>
      keyword(keyword, level + 1) <>
      compileClassVarDec(left_over_tokens, level + 1);
    end
  end

  ## subroutineDec: ('constructor', 'function', 'method')
  def compileClassDec(
    [%{tokenType: :keyword, keyword: keyword}
    | left_over_tokens ], level)
  when keyword in [:constructor, :function, :method] do
      indent(level) <> '<subroutineDec>\n' <>
      keyword(keyword, level + 1) <>
      compileSubroutineDec(left_over_tokens, level + 1);
    end
  end

  # type 'int' | 'char' | 'boolean' varName
  def compileClassVarDec(
    [%{tokenType: :keyword, keyword: keyword},
     %{tokenType: :identifier, identifier: varname}
    | left_over_tokens ], level)
  when keyword in ['int', 'char', 'boolean'] do
    keyword(keyword, level) <>
    identifier(varname, level) <>
    compileClassVarDec(left_over_tokens, level);
  end

  # type className varName
  def compileClassVarDec(
    [%{tokenType: :identifier, identifier: className},
     %{tokenType: :identifier, identifier: varName}
    | left_over_tokens ], level
  ) do
    identifier(className, level) <>
    identifier(varName, level) <>
    compileClassVarDec(left_over_tokens, level);
  end

  # ,varName *
  def compileClassVarDec(
    [%{tokenType: :symbol, symbol: ','},
     %{tokenType: :identifier, identifier: varName}
    | left_over_tokens ], level]
  ) do
    identifier(varName, level) <>
    compileClassVarDec(left_over_tokens, level);
  end

  # ;
  def compileClassVarDec(
    [%{tokenType: :symbol, symbol: ';'} | left_over_tokens ], level]
  ) do
    indent(level - 1) <> '</classVarDec>\n' <>
    compileClassDec(left_over_tokens, level);

  # ('void' | 'int' | 'char' | 'boolean') subroutineName '('
  def compileSubroutineDec(
    [%{tokenType: :keyword, keyword: keyword},
      %{tokenType: :identifier, identifier: subroutineName},
      %{tokenType: :symbol, symbol: '('}
    | left_over_tokens ], level)
  when keyword in ['void', 'int', 'char', 'boolean'] do
    keyword(keyword, level) <>
    identifier(subroutineName, level) <>
    symbol('(', level) <>
    compileSubroutineDec(left_over_tokens, level);
  end

  # className subroutineName '('
  def compileSubroutineDec(
    [%{tokenType: :identifier, identifier: className},
     %{tokenType: :identifier, identifier: subroutineName},
     %{tokenType: :symbol, symbol: '('}
    | left_over_tokens ], level)
  when keyword in ['void'] do
    identifier(className, level) <>
    identifier(subroutineName, level) <>
    symbol('(', level) <>
    symbol('<parameterList>', level) <>
    compileParameterList(left_over_tokens, level + 1);
  end

  def compileSubroutineDec(
    [%{tokenType: :symbol, identifier: '{'}, | _ ] = tokens, level)
  when keyword in ['void'] do
    compileSubroutineBody(tokens, level);
  end

  def compileSubroutineDec(tokens, level) do
    indent(level) <> '</subroutineDec>\n' <>
    compileClassDeclaration(tokens, level - 1)
  end

  # type 'void' | 'int' | 'char' varName
  def compileParameterList(
    [%{tokenType: :keyword, keyword: keyword},
     %{tokenType: :identifier, identifier: varName},
    | left_over_tokens ], level)
  when keyword in ['int', 'char', 'boolean'] do
    keyword(keyword, level) <>
    identifier(varName, level) <>
    compileParameterList(left_over_tokens, level);
  end

  #  type className varName
  def compileParameterList(
    [%{tokenType: :identifier, identifier: className},
     %{tokenType: :identifier, identifier: varName},
    | left_over_tokens ], level
  ) do
    identifier(className, level) <>
    identifier(varName, level) <>
    compileParameterList(left_over_tokens, level);
  end

  #  ',' type 'void' | 'int' | 'char' varName
  def compileParameterList(
    [%{tokenType: :symbol, symbol: ','}
     %{tokenType: :keyword, keyword: keyword},
     %{tokenType: :identifier, identifier: varName},
    | left_over_tokens ], level)
  when keyword in ['int', 'char', 'boolean'] do
    symbol(',', level) <>
    keyword(keyword, level) <>
    identifier(varName, level) <>
    compileParameterList(left_over_tokens, level);
  end

  #  ',' type className varName
  def compileParameterList(
    [%{tokenType: :symbol, symbol: ','},
     %{tokenType: :identifier, identifier: className},
     %{tokenType: :identifier, identifier: varName},
    | left_over_tokens ], level
  ) do
    symbol(',', level) <>
    identifier(className, level) <>
    identifier(varName, level) <>
    compileParameterList(left_over_tokens, level);
  end

  # ")"
  def compileParameterList(
    [%{tokenType: :symbol, symbol: ')'}
    | left_over_tokens ], level
  ) do
    symbol(')', level) <>
    symbol('</parameterList>', level) <>
    compileSubroutineBody(left_over_tokens, level -1)
  end

  # subroutineBody: '{' varDec* statements '}'
  def compileSubroutineBody(
    [%{tokenType: :symbol, identifier: '{'}, | left_over_tokens ], level
  ) do
    symbol('<subroutineBody>', level) <>
    symbol('{', level + 1) <>
    compileSubroutineBody(level + 1)
  end

  # 'var' type 'void' | 'int' | 'char' varName
  def compileSubroutineBody(
     [%{tokenType: :keyword, keyword: :var},
      %{tokenType: :keyword, keyword: keyword},
      %{tokenType: :identifier, identifier: varName}
    | left_over_tokens ], level)
  when keyword in ['int', 'char', 'boolean'])  do
    keyword(:varDec, level) <>
    keyword(:var, level + 1) <>
    keyword(keyword, level + 1) <>
    identifier(keyword, varName + 1) <>
    compileVariableDeclaration(left_over_tokens, level + 1)
  end

  # 'var' type className varName
  def compileSubroutineBody(
     [%{tokenType: :keyword, keyword: :var},
      %{tokenType: :identifier, identifier: className},
      %{tokenType: :identifier, identifier: varName}
    | left_over_tokens ], level
  ) do
    indent(level) <> '<varDec>' <>
    keyword(:var, level + 1) <>
    identifier(className, level + 1) <>
    identifier(varName, level + 1) <>
    compileVariableDeclaration(left_over_tokens, level + 1)
  end

  def compileSubroutineBody(
    tokens, level
  ) do
    keyword(:statements, level) <>
    indent(level) <> '<statements>'<>
    compileStatements(token, level + 1)
  end

  # (',' varName)*
  def compileVariableDeclaration(
     [%{tokenType: :symbol, keyword: ','},
      %{tokenType: :identifier, identifier: varName}
    | left_over_tokens ], level
  ) do
    symbol(',', level) <>
    identifier(keyword, varName) <>
    compileVariableDeclaration(left_over_tokens, level)
  end

  #';'
  def compileVariableDeclaration(
     [%{tokenType: :symbol, keyword: ';'}
    | left_over_tokens ], level
  ) do
    symbol(';', level) <>
    indent(level- 1) <> '</varDec>' <>
    compileSubroutineBody(left_over_tokens, level - 1)
  end

  #FIXME! compileStatements

  def compileStatements(
    [%{tokenType: :symbol, keyword: '}'}
    | left_over_tokens ], level
  ) do
    indent(level) <> '</statements>'<>
    symbol('}', level) <>
    indent(level- 1) <> '</subroutineBody>'<>
    compileSubroutineDec(left_over_tokens, level - 1)
  end

  #!FIXME expressions to be inserted here

  def indent(level) do
    indent_by_spaces = 2
    String.duplicate(" ", level * indent_by_spaces)
  end

  def keyword(value, level), do: terminal(:keyword, value, level)
  def identifier(value, level), do: terminal(:identifier, value, level)
  def symbol(value, level), do: terminal(:symbol, value, level)

  def terminal(tag, value, level) do
    indent(level) <> #indentation
    '<' <> Atom.to_string(tag) <> '> ' <> # Opening Tag
    value <> # Value
    ' </' <> Atom.to_string(tag) <> '>\n' # Closing Tag + Newline
  end
end
