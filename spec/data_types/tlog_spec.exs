defmodule Jylis.TLOG.Spec do
  use ESpec

  let :connection, do: self()
  let :key,        do: "temperature"
  let :count,      do: 20
  let :value,      do: 72.1
  let :timestamp,  do: 1528238308
  let :iso8601,    do: "2018-06-05T22:38:28Z"

  describe "get" do
    specify do
      allow Jylis |> to(accept :query, fn(conn, params) ->
        conn   |> should(eq connection())
        params |> should(eq ["TLOG", "GET", key()])

        {:ok, [
          ["68", 1],
          ["70", 2],
        ]}
      end)

      expected = [
        {"68", 1},
        {"70", 2},
      ]

      Jylis.TLOG.get(connection(), key()) |> should(eq {:ok, expected})

      expect Jylis |> to(accepted :query)
    end

    it "passes through errors" do
      allow Jylis |> to(accept :query, fn(conn, params) ->
        conn   |> should(eq connection())
        params |> should(eq ["TLOG", "GET", key()])

        {:error, nil}
      end)

      Jylis.TLOG.get(connection(), key()) |> should(eq {:error, nil})

      expect Jylis |> to(accepted :query)
    end
  end

  describe "ins" do
    specify do
      allow Jylis |> to(accept :query, fn(conn, params) ->
        conn   |> should(eq connection())
        params |> should(eq ["TLOG", "INS", key(), value(), timestamp()])

        {:ok, "OK"}
      end)

      Jylis.TLOG.ins(connection(), key(), value(), timestamp())
      |> should(eq {:ok, "OK"})

      expect Jylis |> to(accepted :query)
    end

    specify "with iso8601 timestamp" do
      allow Jylis |> to(accept :query, fn(conn, params) ->
        conn   |> should(eq connection())
        params |> should(eq ["TLOG", "INS", key(), value(), timestamp()])

        {:ok, "OK"}
      end)

      Jylis.TLOG.ins(connection(), key(), value(), iso8601())
      |> should(eq {:ok, "OK"})

      expect Jylis |> to(accepted :query)
    end
  end

  specify "size" do
    allow Jylis |> to(accept :query, fn(conn, params) ->
      conn   |> should(eq connection())
      params |> should(eq ["TLOG", "SIZE", key()])

      {:ok, 1}
    end)

    Jylis.TLOG.size(connection(), key()) |> should(eq {:ok, 1})

    expect Jylis |> to(accepted :query)
  end

  specify "cutoff" do
    allow Jylis |> to(accept :query, fn(conn, params) ->
      conn   |> should(eq connection())
      params |> should(eq ["TLOG", "CUTOFF", key()])

      {:ok, 0}
    end)

    Jylis.TLOG.cutoff(connection(), key()) |> should(eq {:ok, 0})

    expect Jylis |> to(accepted :query)
  end

  describe "trimat" do
    specify do
      allow Jylis |> to(accept :query, fn(conn, params) ->
        conn   |> should(eq connection())
        params |> should(eq ["TLOG", "TRIMAT", key(), timestamp()])

        {:ok, "OK"}
      end)

      Jylis.TLOG.trimat(connection(), key(), timestamp())
      |> should(eq {:ok, "OK"})

      expect Jylis |> to(accepted :query)
    end

    specify "with iso8601 timestamp" do
      allow Jylis |> to(accept :query, fn(conn, params) ->
        conn   |> should(eq connection())
        params |> should(eq ["TLOG", "TRIMAT", key(), timestamp()])

        {:ok, "OK"}
      end)

      Jylis.TLOG.trimat(connection(), key(), iso8601())
      |> should(eq {:ok, "OK"})

      expect Jylis |> to(accepted :query)
    end
  end

  specify "trim" do
    allow Jylis |> to(accept :query, fn(conn, params) ->
      conn   |> should(eq connection())
      params |> should(eq ["TLOG", "TRIM", key(), count()])

      {:ok, "OK"}
    end)

    Jylis.TLOG.trim(connection(), key(), count()) |> should(eq {:ok, "OK"})

    expect Jylis |> to(accepted :query)
  end

  specify "clr" do
    allow Jylis |> to(accept :query, fn(conn, params) ->
      conn   |> should(eq connection())
      params |> should(eq ["TLOG", "CLR", key()])

      {:ok, "OK"}
    end)

    Jylis.TLOG.clr(connection(), key()) |> should(eq {:ok, "OK"})

    expect Jylis |> to(accepted :query)
  end
end
