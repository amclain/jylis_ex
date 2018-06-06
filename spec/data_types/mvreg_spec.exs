defmodule Jylis.MVREGSpec do
  use ESpec

  let :connection, do: self()
  let :key,        do: "temperature"
  let :value,      do: 25

  specify "get" do
    db_value = ["#{value()}"]

    allow(Jylis).to accept(:query, fn(conn, params) ->
      conn   |> should(eq connection())
      params |> should(eq ["MVREG", "GET", key()])

      {:ok, db_value}
    end)

    Jylis.MVREG.get(connection(), key()) |> should(eq {:ok, db_value})

    expect(Jylis).to accepted(:query)
  end

  specify "set" do
    allow(Jylis).to accept(:query, fn(conn, params) ->
      conn   |> should(eq connection())
      params |> should(eq ["MVREG", "SET", key(), value()])

      {:ok, "OK"}
    end)

    Jylis.MVREG.set(connection(), key(), value()) |> should(eq {:ok, "OK"})

    expect(Jylis).to accepted(:query)
  end
end
