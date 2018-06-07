defmodule Jylis.UJSON.Spec do
  use ESpec

  let :connection, do: self()
  let :key,        do: "fruit"
  let :key2,       do: "apple"
  let :value,      do: "red"
  let :values,     do: %{
    "apple"    => "red",
    "banana"   => "yellow",
    "cucumber" => "green",
  }

  describe "get" do
    specify "with a single key" do
      allow(Jylis).to accept(:query, fn(conn, params) ->
        conn   |> should(eq connection())
        params |> should(eq ["UJSON", "GET", key()])

        {:ok, Poison.encode!(values())}
      end)

      Jylis.UJSON.get(connection(), key()) |> should(eq {:ok, values()})

      expect(Jylis).to accepted(:query)
    end

    specify "with multiple keys" do
      allow(Jylis).to accept(:query, fn(conn, params) ->
        conn   |> should(eq connection())
        params |> should(eq ["UJSON", "GET", key(), key2()])

        {:ok, Poison.encode!(value())}
      end)

      keys = [key(), key2()]

      Jylis.UJSON.get(connection(), keys) |> should(eq {:ok, value()})

      expect(Jylis).to accepted(:query)
    end

    it "passes through errors" do
      allow(Jylis).to accept(:query, fn(conn, params) ->
        conn   |> should(eq connection())
        params |> should(eq ["UJSON", "GET", key()])

        {:error, nil}
      end)

      Jylis.UJSON.get(connection(), key()) |> should(eq {:error, nil})

      expect(Jylis).to accepted(:query)
    end
  end

  describe "set" do
    specify "with a single key" do
      allow(Jylis).to accept(:query, fn(conn, params) ->
        conn   |> should(eq connection())
        params |> should(eq [
          "UJSON",
          "SET",
          key(),
          Poison.encode!(values()),
        ])

        {:ok, "OK"}
      end)

      Jylis.UJSON.set(connection(), key(), values()) |> should(eq {:ok, "OK"})

      expect(Jylis).to accepted(:query)
    end

    specify "with multiple keys" do
      allow(Jylis).to accept(:query, fn(conn, params) ->
        conn   |> should(eq connection())
        params |> should(eq [
          "UJSON",
          "SET",
          key(),
          key2(),
          Poison.encode!(value()),
        ])

        {:ok, "OK"}
      end)

      keys = [key(), key2()]

      Jylis.UJSON.set(connection(), keys, value()) |> should(eq {:ok, "OK"})

      expect(Jylis).to accepted(:query)
    end
  end

  describe "clr" do
    specify "with a single key" do
      allow(Jylis).to accept(:query, fn(conn, params) ->
        conn   |> should(eq connection())
        params |> should(eq ["UJSON", "CLR", key()])

        {:ok, "OK"}
      end)

      Jylis.UJSON.clr(connection(), key()) |> should(eq {:ok, "OK"})

      expect(Jylis).to accepted(:query)
    end

    specify "with multiple keys" do
      allow(Jylis).to accept(:query, fn(conn, params) ->
        conn   |> should(eq connection())
        params |> should(eq ["UJSON", "CLR", key(), key2()])

        {:ok, "OK"}
      end)

      keys = [key(), key2()]

      Jylis.UJSON.clr(connection(), keys) |> should(eq {:ok, "OK"})

      expect(Jylis).to accepted(:query)
    end
  end

  describe "ins" do
    specify "with a single key" do
      allow(Jylis).to accept(:query, fn(conn, params) ->
        conn   |> should(eq connection())
        params |> should(eq ["UJSON", "INS", key(), Poison.encode!(value())])

        {:ok, "OK"}
      end)

      Jylis.UJSON.ins(connection(), key(), value()) |> should(eq {:ok, "OK"})

      expect(Jylis).to accepted(:query)
    end

    specify "with multiple keys" do
      allow(Jylis).to accept(:query, fn(conn, params) ->
        conn   |> should(eq connection())
        params |> should(eq [
          "UJSON",
          "INS",
          key(),
          key2(),
          Poison.encode!(value()),
        ])

        {:ok, "OK"}
      end)

      keys = [key(), key2()]

      Jylis.UJSON.ins(connection(), keys, value()) |> should(eq {:ok, "OK"})

      expect(Jylis).to accepted(:query)
    end
  end

  describe "rm" do
    specify "with a single key" do
      allow(Jylis).to accept(:query, fn(conn, params) ->
        conn   |> should(eq connection())
        params |> should(eq ["UJSON", "RM", key(), Poison.encode!(value())])

        {:ok, "OK"}
      end)

      Jylis.UJSON.rm(connection(), key(), value()) |> should(eq {:ok, "OK"})

      expect(Jylis).to accepted(:query)
    end

    specify "with multiple keys" do
      allow(Jylis).to accept(:query, fn(conn, params) ->
        conn   |> should(eq connection())
        params |> should(eq [
          "UJSON",
          "RM",
          key(),
          key2(),
          Poison.encode!(value()),
        ])

        {:ok, "OK"}
      end)

      keys = [key(), key2()]

      Jylis.UJSON.rm(connection(), keys, value()) |> should(eq {:ok, "OK"})

      expect(Jylis).to accepted(:query)
    end
  end
end
