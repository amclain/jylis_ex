defmodule Jylis.Result do
  @moduledoc """
  Transformations for Jylis query results.
  """

  @doc """
  Convert the Unix timestamp in a query result to ISO 8601.

  `query_result` - A query result tuple in the form `{value, timestamp}`.
  """
  def to_iso8601(query_result)

  def to_iso8601({value, timestamp}) do
    {:ok, date_time} = timestamp |> DateTime.from_unix
    timestamp        = date_time |> DateTime.to_iso8601

    {value, timestamp}
  end
end
