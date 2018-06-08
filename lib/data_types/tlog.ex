defmodule Jylis.TLOG do
  @moduledoc """
  A timestamped log.
  <sup>[[link](https://jemc.github.io/jylis/docs/types/tlog/)]</sup>
  """

  @doc """
  Get the latest `value` and `timestamp` for the register at `key`.

  Returns `{:ok, [{value, timestamp}, ...]}` on success.
  """
  def get(connection, key) do
    result = connection |> Jylis.query(["TLOG", "GET", key])

    case result do
      {:ok, items} ->
        items = items |> Enum.map(fn(item) -> List.to_tuple(item) end)
        {:ok, items}

      error -> error
    end
  end

  @doc """
  Insert a `value`/`timestamp` entry into the log at `key`.

  `timestamp` - An integer Unix timestamp or an ISO 8601 formatted string.
  """
  def ins(connection, key, value, timestamp) when is_integer(timestamp) do
    connection |> Jylis.query(["TLOG", "INS", key, value, timestamp])
  end

  def ins(connection, key, value, timestamp) when is_binary(timestamp) do
    {:ok, date_time, _} = timestamp |> DateTime.from_iso8601
    timestamp           = date_time |> DateTime.to_unix

    ins(connection, key, value, timestamp)
  end

  @doc """
  Return the number of entries in the log at `key` as an integer.
  """
  def size(connection, key) do
    connection |> Jylis.query(["TLOG", "SIZE", key])
  end

  @doc """
  Return the current cutoff timestamp of the log at `key` as an integer.
  """
  def cutoff(connection, key) do
    connection |> Jylis.query(["TLOG", "CUTOFF", key])
  end

  @doc """
  Raise the cutoff timestamp of the log, causing any entries to be discarded
  whose timestamp is earlier than the newly given `timestamp`.

  `timestamp` - An integer Unix timestamp or an ISO 8601 formatted string.
  """
  def trimat(connection, key, timestamp) when is_integer(timestamp) do
    connection |> Jylis.query(["TLOG", "TRIMAT", key, timestamp])
  end

  def trimat(connection, key, timestamp) when is_binary(timestamp) do
    {:ok, date_time, _} = timestamp |> DateTime.from_iso8601
    timestamp           = date_time |> DateTime.to_unix

    trimat(connection, key, timestamp)
  end

  @doc """
  Raise the cutoff timestamp of the log to retain at least `count` entries, by
  setting the cutoff timestamp to the timestamp of the entry at index `count - 1`
  in the log. Any entries with an earlier timestamp than the entry at that index
  will be discarded. If `count` is zero, this is the same as calling `clr/2`.
  """
  def trim(connection, key, count) do
    connection |> Jylis.query(["TLOG", "TRIM", key, count])
  end

  @doc """
  Raise the cutoff timestamp to be the timestamp of the latest entry plus
  one, such that all local entries in the log will be discarded due to having
  timestamps earlier than the cutoff timestamp.
  """
  def clr(connection, key) do
    connection |> Jylis.query(["TLOG", "CLR", key])
  end
end
