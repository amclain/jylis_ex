defmodule Jylis.UJSON do
  @moduledoc """
  Unordered JSON.
  <sup>[[link](https://jemc.github.io/jylis/docs/types/ujson/)]</sup>
  """

  @doc """
  Get the JSON representation of the data currently held at `key`.

  `keys` - A single key or `List` of keys.
  """
  def get(connection, keys) when is_list(keys) do
    result = connection |> Jylis.query(["UJSON", "GET" | keys])

    case result do
      {:ok, json} -> {:ok, Poison.decode!(json)}
      error       -> error
    end
  end

  def get(connection, key), do: get(connection, [key])

  @doc """
  Store the given `ujson` data at the given `key`.

  `keys` - A single key or `List` of keys.
  """
  def set(connection, keys, value) when is_list(keys) do
    json = Poison.encode!(value)

    connection |> Jylis.query(["UJSON", "SET"] ++ keys ++ [json])
  end

  def set(connection, key, value), do: set(connection, [key], value)

  @doc """
  Remove all data stored at or under the given `key`.

  `keys` - A single key or `List` of keys.
  """
  def clr(connection, keys) when is_list(keys) do
    connection |> Jylis.query(["UJSON", "CLR" | keys])
  end

  def clr(connection, key), do: clr(connection, [key])

  @doc """
  Insert the given `value` as a new element in the set of values stored
  at `key`.

  `keys` - A single key or `List` of keys.
  """
  def ins(connection, keys, value) when is_list(keys) do
    json = Poison.encode!(value)

    connection |> Jylis.query(["UJSON", "INS"] ++ keys ++ [json])
  end

  def ins(connection, key, value), do: ins(connection, [key], value)

  @doc """
  Remove the specified `value` from the set of values stored at `key`.

  `keys` - A single key or `List` of keys.
  """
  def rm(connection, keys, value) when is_list(keys) do
    json = Poison.encode!(value)

    connection |> Jylis.query(["UJSON", "RM"] ++ keys ++ [json])
  end

  def rm(connection, key, value), do: rm(connection, [key], value)
end
