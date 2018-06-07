# jylis_ex

[![Hex.pm](https://img.shields.io/hexpm/v/jylis_ex.svg)](https://hex.pm/packages/jylis_ex)
[![Coverage Status](https://coveralls.io/repos/github/amclain/jylis_ex/badge.svg?branch=master)](https://coveralls.io/github/amclain/jylis_ex?branch=master)
[![API Documentation](http://img.shields.io/badge/docs-api-blue.svg)](https://hexdocs.pm/jylis_ex)
[![MIT License](https://img.shields.io/badge/license-MIT-yellowgreen.svg)](https://github.com/amclain/jylis_ex/blob/master/license.txt)

An idiomatic library for connecting an Elixir project to a
[Jylis](https://github.com/jemc/jylis) database.

> Jylis is a distributed in-memory database for Conflict-free Replicated Data
> Types (CRDTs), built for speed, scalability, availability, and ease of use.

## Installation

Add the `:jylis_ex` dependency to your `mix.exs` file:

```elixir
defp deps() do
  [{:jylis_ex, ">= 0.0.0"}]
end
```

Run `mix deps.get` to get the new dependency.

## Database Connection

The connection URI must be specified in the format: `schema://host:port`, where
the schema is `jylis`. The `host` can be a host name, IP address, or domain name
of the database host to connect to. The `port` is optional and defaults to
`6379` unless otherwise specified.

```elixir
{:ok, connection} = Jylis.start_link("jylis://host:port")
```

## Queries

### GCOUNT

Grow-Only Counter <sup>[[link](https://jemc.github.io/jylis/docs/types/gcount/)]</sup>

```elixir
{:ok, _} = connection |> Jylis.GCOUNT.inc("mileage", 10)
{:ok, _} = connection |> Jylis.GCOUNT.inc("mileage", 5)

{:ok, value} = connection |> Jylis.GCOUNT.get("mileage")
# {:ok, 15}
```

### MVREG

Multi-Value Register <sup>[[link](https://jemc.github.io/jylis/docs/types/mvreg/)]</sup>

```elixir
{:ok, _} = connection |> Jylis.MVREG.set("thermostat", 68)
# {:ok, "OK"}

{:ok, value} = connection |> Jylis.MVREG.get("thermostat")
# {:ok, ["68"]}
```
