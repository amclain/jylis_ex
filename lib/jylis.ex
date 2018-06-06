defmodule Jylis do
  @moduledoc """
  Jylis database adapter.
  """

  @doc """
  Start a connection to Jylis.

  `server_uri` - A URI in the format `jylis://host:port`. The schema must
    be `jylis`. The `host` can be a valid hostname, IP address, or domain name.
    The `port` is optional and defaults to `6379`.

  Returns `{:ok, pid}` on success, or `{:error, error}` on failure.
  """
  def start_link(server_uri) do
    server_uri = URI.parse(server_uri)

    case validate_uri(server_uri) do
      {:error, error} ->
        {:error, error}

      :ok ->
        port = server_uri.port || 6379

        Redix.start_link(host: server_uri.host, port: port)
    end
  end

  defp validate_uri(server_uri) do
    cond do
      (server_uri.scheme || "") |> String.downcase != "jylis" ->
        {:error, :invalid_schema}

      server_uri.host |> is_nil() ->
        {:error, :invalid_host}

      !is_nil(server_uri.port) && !is_integer(server_uri.port) ->
        {:error, :invalid_port}

      true ->
        :ok
    end
  end
end
