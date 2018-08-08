defmodule Jylis do
  @moduledoc """
  Jylis database adapter.
  """

  @doc """
  Start a connection to Jylis.

  `server_uri` - A URI in the format `jylis://host:port`. The schema must
    be `jylis`. The `host` can be a valid hostname, IP address, or domain name.
    The `port` is optional and defaults to `6379`.

  `opts`
    * `name` - A name to register the process to.

  Returns `{:ok, pid}` on success, or `{:error, error}` on failure.
  """
  def start_link(server_uri, opts \\ []) do
    server_uri = URI.parse(server_uri)

    case validate_uri(server_uri) do
      {:error, error} ->
        {:error, error}

      :ok ->
        port = server_uri.port || 6379
        name = opts |> Keyword.get(:name)

        Redix.start_link([host: server_uri.host, port: port], name: name)
    end
  end

  @doc """
  Close a connection to Jylis.

  `timeout` - Timeout in milliseconds.
  """
  def stop(connection, timeout \\ :infinity) do
    connection |> Redix.stop(timeout)
  end

  @doc """
  Make a query to the database.

  `command` - A `List` of command parameters. The command follows the format
    specified for a function in the Jylis [data types](https://jemc.github.io/jylis/docs/types/)
    documentation.

  Returns `{:ok, result}` on success.
  """
  def query(connection, command) do
    connection |> Redix.command(command)
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
