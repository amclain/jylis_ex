defmodule Benchmark.Queries do
  def before_scenario(_) do
    {:ok, connection} = Jylis.start_link("jylis://localhost")
    connection
  end

  def after_scenario(connection) do
    connection |> Jylis.stop
  end

  def treg_set_get(connection) do
    {:ok, _} = connection |> Jylis.TREG.set("temperature", 68, 10)
    {:ok, _} = connection |> Jylis.TREG.get("temperature")

    connection
  end

  def tlog_ins_get(connection) do
    # TODO: increment timestamp ################################################
    {:ok, _} = connection |> Jylis.TLOG.ins("temperature", 68, 10)
    {:ok, _} = connection |> Jylis.TLOG.get("temperature")

    connection
  end

  def gcount_inc_get(connection) do
    {:ok, _} = connection |> Jylis.GCOUNT.inc("mileage", 10)
    {:ok, _} = connection |> Jylis.GCOUNT.get("mileage")

    connection
  end

  def pncount_inc_dec_get(connection) do
    {:ok, _} = connection |> Jylis.PNCOUNT.inc("subscribers", 9)
    {:ok, _} = connection |> Jylis.PNCOUNT.dec("subscribers", 4)
    {:ok, _} = connection |> Jylis.PNCOUNT.get("subscribers")

    connection
  end

  def mvreg_set_get(connection) do
    {:ok, _} = connection |> Jylis.MVREG.set("temperature", 68)
    {:ok, _} = connection |> Jylis.MVREG.get("temperature")

    connection
  end

  def ujson_set_get(connection) do
    {:ok, _} = connection |> Jylis.UJSON.set(["user", "alice", "admin"], true)
    {:ok, _} = connection |> Jylis.UJSON.get("user")

    connection
  end
end

compose_file = "benchmark/docker/docker-compose.yml"

System.cmd("docker-compose", ["-f", compose_file, "up", "-d"])

benchmarks = %{
  "TREG set/get"        => &Benchmark.Queries.treg_set_get/1,
  "TLOG ins/get"        => &Benchmark.Queries.tlog_ins_get/1,
  "GCOUNT inc/get"      => &Benchmark.Queries.gcount_inc_get/1,
  "PNCOUNT inc/dec/get" => &Benchmark.Queries.pncount_inc_dec_get/1,
  "MVREG set/get"       => &Benchmark.Queries.mvreg_set_get/1,
  "UJSON set/get"       => &Benchmark.Queries.ujson_set_get/1,
}

Benchee.run benchmarks,
  warmup:          5,
  console:         %{comparison: false, extended_statistics: true},
  before_scenario: &Benchmark.Queries.before_scenario/1,
  after_scenario:  &Benchmark.Queries.after_scenario/1

System.cmd("docker-compose", ["-f", compose_file, "down"])
