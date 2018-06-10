defmodule Jylis.Protocol do
  @moduledoc """
  Jylis message serializer.

  Note that Jylis uses the [Redis protocol](https://redis.io/topics/protocol).
  """

  @doc """
  Serialize a request to the database.

  `request` - A `List` of request parameters.
  """
  def serialize(request), do: request |> do_serialize_array

  defp do_serialize({output, []}), do: output
  defp do_serialize({output, [input | tail]}) do
    length = input |> String.length
    output = output <> "$#{length}\r\n#{input}\r\n"

    {output, tail} |> do_serialize
  end

  # ----------------------------------------------------------------------------
  # TODO: There are arrays of values in UJSON ##################################
  # ----------------------------------------------------------------------------
  defp do_serialize_array(input) when is_list(input), 
    do: {"", input} |> do_serialize_array

  defp do_serialize_array({output, input}) do
    element_count = input |> Enum.count
    output        = output <> "*#{element_count}\r\n"

    {output, input} |> do_serialize
  end

  @doc """
  Deserialize a response from the database.
  """
  def deserialize(response) do
    {:ok, input_io} = StringIO.open(response)

    result = input_io |> parse
    input_io |> StringIO.close

    result
  end

  defp parse(input) do
    input
    |> IO.binread(1)
    |> check_data_type_byte(input)
  end

  defp check_data_type_byte("+",   input), do: input |> parse_simple_string
  defp check_data_type_byte("-",   input), do: input |> parse_error
  defp check_data_type_byte(":",   input), do: input |> parse_integer
  defp check_data_type_byte("$",   input), do: input |> parse_bulk_string
  defp check_data_type_byte("*",   input), do: input |> parse_array
  defp check_data_type_byte(:eof, _input), do: {:error, :unexpected_eof}

  defp parse_simple_string(input) do
    bytes = input |> read_line

    {:ok, bytes}
  end

  defp parse_error(input) do
    [error_type, message] = input |> read_line |> String.split(" ", parts: 2)
    error_atom            = error_type |> String.downcase |> String.to_atom

    # TODO: Errors are actually `:ok` at this point??? #########################
    {:error, {error_atom, message}}
  end

  defp parse_integer(input) do
    integer = input |> read_line |> String.to_integer

    {:ok, integer}
  end

  defp parse_bulk_string(input) do
    input
    |> read_line
    |> String.to_integer
    |> check_bulk_string_length(input)
  end

  defp check_bulk_string_length(-1, _input) do
    {:ok, nil}
  end

  defp check_bulk_string_length(count, input) when count >= 0 do
    bytes = input |> IO.binread(count)

    case input |> IO.binread(2) do
      "\r\n" -> {:ok, bytes}
      _      -> {:error, {:protocol, "Failed to parse bulk string"}}
    end
  end

  defp parse_array(input) do
    case input |> read_line |> String.to_integer do
       0    -> {:ok, []}
      -1    -> {:ok, nil}
      count ->
        result =
          1..count
          |> Enum.reduce([], fn(_i, acc) ->
            {:ok, value} = input |> parse

            [value | acc]
          end)
          |> Enum.reverse

        {:ok, result}
    end
  end

  defp read_line(input) do
    # TODO: Replace :line with a true matcher for "\r\n" #######################
    input |> IO.binread(:line) |> String.trim_trailing
  end
end
