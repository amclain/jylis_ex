defmodule Integration.Spec do
  use ESpec, async: false

  def start_server do
    System.cmd("docker-compose", ["-f", "docker/docker-compose.yml", "up", "-d"])
  end

  def stop_server do
    System.cmd("docker-compose", ["-f", "docker/docker-compose.yml", "down"])
  end

  def reset_server do
    stop_server()
    start_server()
  end

  let :connection do
    {:ok, conn} = Jylis.start_link("jylis://localhost")
    conn
  end

  # Since Jylis is an in-memory database, we restart it between each test group
  # to purge the database.
  before do: reset_server()

  finally do
    connection() |> Jylis.stop
    stop_server()
  end

  specify "TREG" do
    {:ok, _} = connection() |> Jylis.TREG.set("temperature", 72.1, 1528238308)

    {:ok, {value, timestamp}} = connection() |> Jylis.TREG.get("temperature")

    timestamp |> should(eq 1528238308)
    value     |> should(eq "72.1")
  end

  specify "TLOG" do
    {:ok, _} = connection() |> Jylis.TLOG.ins("temperature", 68, 1528238310)
    {:ok, _} = connection() |> Jylis.TLOG.ins("temperature", 70, 1528238320)
    {:ok, _} = connection() |> Jylis.TLOG.ins("temperature", 73, 1528238330)

    {:ok, values} = connection() |> Jylis.TLOG.get("temperature")
    values |> should(eq [
      {"73", 1528238330},
      {"70", 1528238320},
      {"68", 1528238310},
    ])

    {:ok, size} = connection() |> Jylis.TLOG.size("temperature")
    size |> should(eq 3)

    {:ok, _} = connection() |> Jylis.TLOG.trimat("temperature", 1528238320)

    {:ok, cutoff} = connection() |> Jylis.TLOG.cutoff("temperature")
    cutoff |> should(eq 1528238320)

    {:ok, values} = connection() |> Jylis.TLOG.get("temperature")
    values |> should(eq [
      {"73", 1528238330},
      {"70", 1528238320},
    ])

    {:ok, _} = connection() |> Jylis.TLOG.trim("temperature", 1)

    {:ok, values} = connection() |> Jylis.TLOG.get("temperature")
    values |> should(eq [
      {"73", 1528238330},
    ])

    {:ok, _} = connection() |> Jylis.TLOG.clr("temperature")

    {:ok, values} = connection() |> Jylis.TLOG.get("temperature")
    values |> should(eq [])
  end

  specify "GCOUNT" do
    {:ok, _} = connection() |> Jylis.GCOUNT.inc("mileage", 5)
    {:ok, _} = connection() |> Jylis.GCOUNT.inc("mileage", 10)

    {:ok, value} = connection() |> Jylis.GCOUNT.get("mileage")
    value |> should(eq 15)
  end

  specify "PNCOUNT" do
    {:ok, _} = connection() |> Jylis.PNCOUNT.inc("subscribers", 9)
    {:ok, _} = connection() |> Jylis.PNCOUNT.dec("subscribers", 4)

    {:ok, value} = connection() |> Jylis.PNCOUNT.get("subscribers")
    value |> should(eq 5)
  end

  specify "MVREG" do
    {:ok, _} = connection() |> Jylis.MVREG.set("temperature", 68)

    {:ok, value} = connection() |> Jylis.MVREG.get("temperature")
    value |> should(eq ["68"])
  end

  describe "UJSON" do
    specify "hash values" do
      {:ok, _} = connection() |> Jylis.UJSON.set(["users", "alice"], %{admin: false})
      {:ok, _} = connection() |> Jylis.UJSON.set(["users", "brett"], %{admin: false})
      {:ok, _} = connection() |> Jylis.UJSON.set(["users", "carol"], %{admin: true})

      {:ok, users} = connection() |> Jylis.UJSON.get("users")
      users |> should(eq %{
        "alice" => %{"admin" => false},
        "brett" => %{"admin" => false},
        "carol" => %{"admin" => true},
      })

      {:ok, _} = connection() |> Jylis.UJSON.ins(["users", "brett", "banned"], true)

      {:ok, users} = connection() |> Jylis.UJSON.get("users")
      users |> should(eq %{
        "alice" => %{"admin" => false},
        "brett" => %{"admin" => false, "banned" => true},
        "carol" => %{"admin" => true},
      })

      {:ok, _} = connection() |> Jylis.UJSON.clr(["users", "alice"])

      {:ok, users} = connection() |> Jylis.UJSON.get("users")
      users |> should(eq %{
        "brett" => %{"admin" => false, "banned" => true},
        "carol" => %{"admin" => true},
      })
    end

    specify "array values" do
      {:ok, _} = connection() |> Jylis.UJSON.ins("admins", "carol")

      {:ok, admins} = connection() |> Jylis.UJSON.get("admins")
      admins |> should(eq "carol")

      {:ok, _} = connection() |> Jylis.UJSON.ins("admins", "alice")

      {:ok, admins} = connection() |> Jylis.UJSON.get("admins")
      # List is sorted because order is nondeterministic.
      admins |> Enum.sort |> should(eq ["alice", "carol"])

      {:ok, _} = connection() |> Jylis.UJSON.rm("admins", "carol")

      {:ok, admins} = connection() |> Jylis.UJSON.get("admins")
      admins |> should(eq "alice")
    end
  end
end
