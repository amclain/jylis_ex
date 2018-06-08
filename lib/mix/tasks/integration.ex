defmodule Mix.Tasks.Integration do
  @moduledoc """
  Run the integration tests.
  """

  use Mix.Task

  @doc false
  @shortdoc "Run the integration tests"
  def run(_) do
    {_, return_code} =
      System.cmd("mix", ["test"],
        cd:               "integration",
        into:             IO.stream(:stdio, :line),
        stderr_to_stdout: true
      )

    System.halt(return_code)
  end
end
