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

  # Since Jylis is an in-memory database, we restart it between each test group
  # to purge the database.
  before  do: reset_server()
  finally do: stop_server()

  describe "TREG" do
    let :connection do
      {:ok, conn} = Jylis.start_link("jylis://localhost")
      conn
    end

    finally do: connection() |> Jylis.stop

    specify do
      {:ok, _} = connection() |> Jylis.TREG.set("temperature", 72.1, 1528238308)

      {:ok, {value, timestamp}} = connection() |> Jylis.TREG.get("temperature")

      timestamp |> should(eq 1528238308)
      value     |> should(eq "72.1")
    end
  end

  describe "TLOG" do
    let :connection do
      {:ok, conn} = Jylis.start_link("jylis://localhost")
      conn
    end

    finally do: connection() |> Jylis.stop

    specify do
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
  end
end
