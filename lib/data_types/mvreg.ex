defmodule Jylis.MVREG do
  @moduledoc """
  A multi-value register.
  <sup>[[link](https://jemc.github.io/jylis/docs/types/mvreg/)]</sup>
  """

  @doc """
  Get the latest value(s) for the register at `key`.
  """
  def get(connection, key) do
    connection |> Jylis.query(["MVREG", "GET", key])
  end

  @doc """
  Set the latest `value` for the register at `key`.
  """
  def set(connection, key, value) do
    connection |> Jylis.query(["MVREG", "SET", key, value])
  end
end
