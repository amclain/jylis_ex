defmodule Mix.Tasks.Benchmark do
  @moduledoc """
  Run a benchmark.

  Accepts a list of benchmark file names (without `.exs`) as its arguments.
  """

  use Mix.Task

  @benchmark_dir "benchmark"

  @doc false
  @shortdoc "Run a benchmark"
  def run(names) do
    names |> Enum.each(&do_benchmark/1)
  end

  defp do_benchmark(name) do
    benchmark_file = Path.join([@benchmark_dir, "#{name}.exs"])

    {_, return_code} =
      System.cmd("mix", ["run", benchmark_file],
        into: IO.stream(:stdio, :line)
      )

    System.halt(return_code)
  end
end
