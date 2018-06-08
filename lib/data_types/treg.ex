defmodule Jylis.TREG do
  @moduledoc """
  A timestamped register.
  <sup>[[link](https://jemc.github.io/jylis/docs/types/treg/)]</sup>
  """

  @doc """
  Get the latest `value` and `timestamp` for the register at `key`.

  Returns `{:ok, {value, timestamp}}` on success.
  """
  def get(connection, key) do
    result = connection |> Jylis.query(["TREG", "GET", key])

    case result do
      {:ok, item} -> {:ok, List.to_tuple(item)}
      error       -> error
    end
  end

  @doc """
  Set a `value` and `timestamp` for the register at `key`.

  `timestamp` - An integer Unix timestamp or an ISO 8601 formatted string.
  """
  def set(connection, key, value, timestamp) when is_integer(timestamp) do
    connection |> Jylis.query(["TREG", "SET", key, value, timestamp])
  end

  def set(connection, key, value, timestamp) when is_binary(timestamp) do
    {:ok, date_time, _} = timestamp |> DateTime.from_iso8601
    timestamp           = date_time |> DateTime.to_unix

    set(connection, key, value, timestamp)
  end
end
