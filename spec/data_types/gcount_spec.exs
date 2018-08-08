defmodule Jylis.GCOUNT.Spec do
  use ESpec

  let :connection, do: self()
  let :key,        do: "mileage"
  let :value,      do: 50

  specify "get" do
    allow Jylis |> to(accept :query, fn(conn, params) ->
      conn   |> should(eq connection())
      params |> should(eq ["GCOUNT", "GET", key()])

      {:ok, value()}
    end)

    Jylis.GCOUNT.get(connection(), key()) |> should(eq {:ok, value()})

    expect Jylis |> to(accepted :query)
  end

  specify "inc" do
    allow Jylis |> to(accept :query, fn(conn, params) ->
      conn   |> should(eq connection())
      params |> should(eq ["GCOUNT", "INC", key(), value()])

      {:ok, "OK"}
    end)

    Jylis.GCOUNT.inc(connection(), key(), value()) |> should(eq {:ok, "OK"})

    expect Jylis |> to(accepted :query)
  end
end
