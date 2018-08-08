defmodule Jylis.PNCOUNT.Spec do
  use ESpec

  let :connection, do: self()
  let :key,        do: "mileage"
  let :value,      do: 50

  specify "get" do
    allow Jylis |> to(accept :query, fn(conn, params) ->
      conn   |> should(eq connection())
      params |> should(eq ["PNCOUNT", "GET", key()])

      {:ok, value()}
    end)

    Jylis.PNCOUNT.get(connection(), key()) |> should(eq {:ok, value()})

    expect Jylis |> to(accepted :query)
  end

  specify "inc" do
    allow Jylis |> to(accept :query, fn(conn, params) ->
      conn   |> should(eq connection())
      params |> should(eq ["PNCOUNT", "INC", key(), value()])

      {:ok, "OK"}
    end)

    Jylis.PNCOUNT.inc(connection(), key(), value()) |> should(eq {:ok, "OK"})

    expect Jylis |> to(accepted :query)
  end

  specify "dec" do
    allow Jylis |> to(accept :query, fn(conn, params) ->
      conn   |> should(eq connection())
      params |> should(eq ["PNCOUNT", "DEC", key(), value()])

      {:ok, "OK"}
    end)

    Jylis.PNCOUNT.dec(connection(), key(), value()) |> should(eq {:ok, "OK"})

    expect Jylis |> to(accepted :query)
  end
end
