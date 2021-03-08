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
    IO.inspect %{tokens: Enum.reverse(tokens)}
  end

  def advance({text, tokens}) do
    {text |> String.trim_leading(), tokens}
    |> check_for_each_keyword()
    |> check_for_each_symbol()
    |> check_for_string()
    |> check_for_integer()
    |> check_for_identifier()
    |> advance()
  end

  def check_for_each_keyword(params) do
    Enum.reduce(@keywords, params, &check_for_keyword(&2, &1))
  end

  def check_for_each_symbol(params) do
    Enum.reduce(@symbols, params, &check_for_symbol(&2, &1))
  end

  def remove_comments(text) do
    # remove comments /* */, API comments /* */, single line comments,
    # and lines with whitespace only; respectively
    text
    |>String.replace(~r/\/\*.*\*\//s, "")
    |>String.replace(~r/\/\*\*.*\*\//s, "")
    |>String.replace(~r/\/\/.*\n/, "")
    |>String.replace(~r/^\s*\n/, "")
  end

  def check_for_keyword({text, tokens}, keyword) do
    if text |> String.downcase() |> String.starts_with?(keyword) do
      keyword_length = keyword |> String.length()
      cut_text = text |> String.slice(keyword_length..-1) |> String.trim_leading()
      {cut_text, [%{tokenType: :keyWord, keyWord: String.to_atom(keyword)} | tokens]}
    else
      {text, tokens}
    end
  end

  def check_for_symbol({text, tokens}, symbol) do
    if text |> String.starts_with?(symbol) do
      cut_text = text |> String.slice(String.length(symbol)..-1) |> String.trim_leading()
      {cut_text, [%{tokenType: :symbol, symbol: String.to_atom(symbol)} | tokens]}
    else
      {text, tokens}
    end
  end

  def check_for_string({text, tokens}) do
    match = Regex.run(~r/\A\".*\"/, text)
    if match do
      quoted_string = match |> List.first()
      cut_text = text |> String.slice(String.length(quoted_string)..-1) |> String.trim_leading()
      string_without_quotes = quoted_string |> String.slice(1..-2)
      {cut_text, [%{tokenType: :int_const, value: string_without_quotes} | tokens]}
    else
      {text, tokens}
    end
  end

  def check_for_integer({text, tokens}) do
    int_string = Regex.run(~r/\d*/, text) |> List.first()
    if int_string != "" do
      int_value = int_string |> String.to_integer()
      cut_text = text |> String.slice(String.length(int_string)..-1) |> String.trim_leading()
      { cut_text, [%{tokenType: :int_const, value: int_value} | tokens ]}
    else
      {text, tokens}
    end
  end

  def check_for_identifier({text, tokens}) do
    {text, tokens}
    match = Regex.run(~r/[a-zA-Z_]\w*/, text)
    if match do
      identifier = match |> List.first()
      cut_text = text |> String.slice(String.length(identifier)..-1) |> String.trim_leading()
      {cut_text, [%{tokenType: :identifier, identifier: identifier} | tokens]}
    else
      {text, tokens}
    end
  end
end
