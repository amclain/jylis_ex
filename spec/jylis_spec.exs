defmodule Jylis.Spec do
  use ESpec

  let :server_host, do: "db"
  let :server_port, do: 6379
  let :server_uri,  do: "jylis://#{server_host()}:#{server_port()}"

  describe "start_link" do
    describe "server URI" do
      specify do
        allow(Redix).to accept(:start_link, fn(opts) ->
          opts[:host] |> should(eq server_host())
          opts[:port] |> should(eq server_port())

          {:ok, self()}
        end)

        Jylis.start_link(server_uri()) |> should(eq {:ok, self()})
      end

      describe "defaults to port 6379" do
        let :server_uri, do: "jylis://db"

        specify do
          allow(Redix).to accept(:start_link, fn(opts) ->
            opts[:host] |> should(eq "db")
            opts[:port] |> should(eq 6379)

            {:ok, self()}
          end)

          Jylis.start_link(server_uri()) |> should(eq {:ok, self()})
        end
      end

      describe "can specify a port" do
        let :server_uri, do: "jylis://db:5000"

        specify do
          allow(Redix).to accept(:start_link, fn(opts) ->
            opts[:host] |> should(eq "db")
            opts[:port] |> should(eq 5000)

            {:ok, self()}
          end)

          Jylis.start_link(server_uri()) |> should(eq {:ok, self()})
        end
      end

      describe "requires a schema of jylis://" do
        let :server_uri, do: "redis://db"

        specify do
          Jylis.start_link(server_uri()) |> should(eq {:error, :invalid_schema})
        end
      end

      describe "requires a host" do
        let :server_uri, do: "jylis://"

        specify do
          Jylis.start_link(server_uri()) |> should(eq {:error, :invalid_host})
        end
      end
    end
  end
end
