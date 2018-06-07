defmodule Jylis.PNCOUNT do
  @moduledoc """
  A grow-only counter.
  <sup>[[link](https://jemc.github.io/jylis/docs/types/gcount/)]</sup>
  """

  @doc """
  Get the resulting `value` for the counter at `key`.
  """
  def get(connection, key) do
    connection |> Jylis.query(["PNCOUNT", "GET", key])
  end

  @doc """
  Increase the counter at `key` by the amount of `value`.
  """
  def inc(connection, key, value) do
    connection |> Jylis.query(["PNCOUNT", "INC", key, value])
  end

  @doc """
  Decrease the counter at `key` by the amount of `value`.
  """
  def dec(connection, key, value) do
    connection |> Jylis.query(["PNCOUNT", "DEC", key, value])
  end
end
