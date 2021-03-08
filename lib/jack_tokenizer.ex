defmodule JackTokenizer do
  @keywords ["class", "method", "function", "constructor", "int", "boolean", "char", "void",
             "var", "static", "field", "let", "do", "if", "else", "while", "return", "true",
             "false", "null", "this"]
  @symbols ["{", "}", "(", ")", "[", "]", ".", ",", ";", "+", "-", "*", "/", "&", "|", "<", ">",
            "=", "~"]

  def parse(text) do
    {remove_comments(text), []}
    |> advance()
  end

  def advance({text, tokens}) when text == "" do
    IO.inspect %{tokens: tokens.reverse}
  end

  def advance({text, tokens}) do
    {text |> String.trim_leading(), tokens}
    |> Enum.each(keywords, &check_for_keyword(&1))
    |> Enum.each(symbols, &check_for_symbol(&1))
    |> check_for_string()
    |> check_for_integer()
    |> get_indentifier()
    |> advance()
  end

  def remove_comments(text) do
    text
    # remove comment /* */
    |>String.replace(~r/\/\*.*\*\//s, "")
    # remove API comment /* */
    |>String.replace(~r/\/\*\*.*\*\//s, "")
    # remove single line comment
    |>String.replace(~r/\/\/.*\n/, "")
    # remove lines with whitespace only
    |>String.replace(~r/^\s*\n/, "")
  end

  def check_for_keyword({text, tokens}, keyword) do
    if text |> downcase |> String.starts_with(keyword) do
      keyword_length = keyword |> String.length()
      cut_text = text |> String.slice(keyword_length..-1)
      {cut_text, [{tokenType: :keyword, keyWord: String.to_atom(keyword)} | tokens]}
    else
      {text, tokens}
    end
  end

  def check_for_symbol({text, tokens}, symbol) do
    if text |> String.starts_with(symbol) do
      symbol_length = symbol |> String.length()
      cut_text = text |> String.slice(symbol_length..-1)
      {cut_text, [{tokenType: :symbol, symbol: String.to_atom(symbol)} | tokens]}
    else
      {text, tokens}
    end
  end

  def check_for_string({text, tokens}) do
    quoted_string = Regex.run(~r/\A\".*\"/, string) |> List.first()
    if quoted_string != "" do
      length_with_quotes = quoted_string |> String.length()
      cut_text = quoted_string |> String.slice(length_with_quotes)
      {cut_text, [{tokenType: :int_const, value: int_value} | tokens]}
    else
      {text, tokens}
    end
  end

  def check_for_integer({text, tokens}) do
    int_string = Regex.run(~r/\d*/, text) |> List.first()
    if int_string != "" do
      int_value = int_string |> String.to_integer()
      cut_text = text |> String.slice(String.length(int_string)..-1)
      { cut_text, [{tokenType: :int_const, value: int_value} | tokens ]}
    else
      {text, tokens}
    end
  end

  def get_identifier({text, tokens}) do
    {text, tokens}
    identifier = Regex.run(~r/[:alpha_]\w*/, string) |> List.first()
    if identifier do
      identifier_length = identifier |> String.length()
      cut_text = text |> String.slice(identifier_length..-1)
      {cut_text, [{tokenType: :identifier, identifier: identifier} | tokens]}
    else
      {text, tokens}
    end
  end
end
