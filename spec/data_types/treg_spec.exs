defmodule Jylis.TREG.Spec do
  use ESpec

  let :connection, do: self()
  let :key,        do: "temperature"
  let :value,      do: 72.1
  let :timestamp,  do: 1528238308
  let :iso8601,    do: "2018-06-05T22:38:28Z"

  describe "get" do
    specify do
      allow(Jylis).to accept(:query, fn(conn, params) ->
        conn   |> should(eq connection())
        params |> should(eq ["TREG", "GET", key()])

        {:ok, [to_string(value()), timestamp()]}
      end)

      expected = {to_string(value()), timestamp()}

      Jylis.TREG.get(connection(), key()) |> should(eq {:ok, expected})

      expect(Jylis).to accepted(:query)
    end

    it "passes through errors" do
      allow(Jylis).to accept(:query, fn(conn, params) ->
        conn   |> should(eq connection())
        params |> should(eq ["TREG", "GET", key()])

        {:error, nil}
      end)

      Jylis.TREG.get(connection(), key()) |> should(eq {:error, nil})

      expect(Jylis).to accepted(:query)
    end
  end

  describe "set" do
    specify do
      allow(Jylis).to accept(:query, fn(conn, params) ->
        conn   |> should(eq connection())
        params |> should(eq ["TREG", "SET", key(), value(), timestamp()])

        {:ok, "OK"}
      end)

      Jylis.TREG.set(connection(), key(), value(), timestamp())
      |> should(eq {:ok, "OK"})

      expect(Jylis).to accepted(:query)
    end

    specify "with iso8601 timestamp" do
      allow(Jylis).to accept(:query, fn(conn, params) ->
        conn   |> should(eq connection())
        params |> should(eq ["TREG", "SET", key(), value(), timestamp()])

        {:ok, "OK"}
      end)

      Jylis.TREG.set(connection(), key(), value(), iso8601())
      |> should(eq {:ok, "OK"})

      expect(Jylis).to accepted(:query)
    end
  end
end
