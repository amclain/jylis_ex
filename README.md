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

### TREG

Timestamped Register <sup>[[link](https://jemc.github.io/jylis/docs/types/treg/)]</sup>

```elixir
{:ok, _} = connection |> Jylis.TREG.set("lamp_brightness", 80, 1528082143)

{:ok, result} = connection |> Jylis.TREG.get("lamp_brightness")
# {:ok, {"80", 1528082143}}
```

### TLOG

Timestamped Log <sup>[[link](https://jemc.github.io/jylis/docs/types/tlog/)]</sup>

```elixir
{:ok, _} = connection |> Jylis.TLOG.ins("temperature", 68.8, 1528082150)
{:ok, _} = connection |> Jylis.TLOG.ins("temperature", 70.1, 1528082160)
{:ok, _} = connection |> Jylis.TLOG.ins("temperature", 73.6, 1528082170)

{:ok, size} = connection |> Jylis.TLOG.size("temperature")
# {:ok, 3}

{:ok, items} = connection |> Jylis.TLOG.get("temperature")
# {:ok, [{"73.6", 1528082170}, {"70.1", 1528082160}, {"68.8", 1528082150}]}

{:ok, _} = connection |> Jylis.TLOG.trim("temperature", 1)

{:ok, items} = connection |> Jylis.TLOG.get("temperature")
# {:ok, [{"73.6", 1528082170}]}

{:ok, _} = connection |> Jylis.TLOG.cutoff("temperature")
# {:ok, 1528082170}
```

### GCOUNT

Grow-Only Counter <sup>[[link](https://jemc.github.io/jylis/docs/types/gcount/)]</sup>

```elixir
{:ok, _} = connection |> Jylis.GCOUNT.inc("mileage", 10)
{:ok, _} = connection |> Jylis.GCOUNT.inc("mileage", 5)

{:ok, value} = connection |> Jylis.GCOUNT.get("mileage")
# {:ok, 15}
```

### PNCOUNT

Positive/Negative Counter <sup>[[link](https://jemc.github.io/jylis/docs/types/pncount/)]</sup>

```elixir
{:ok, _} = connection |> Jylis.PNCOUNT.inc("subscribers", 3)
{:ok, _} = connection |> Jylis.PNCOUNT.dec("subscribers", 1)

{:ok, value} = connection |> Jylis.PNCOUNT.get("subscribers")
# {:ok, 2}
```

### MVREG

Multi-Value Register <sup>[[link](https://jemc.github.io/jylis/docs/types/mvreg/)]</sup>

```elixir
{:ok, _} = connection |> Jylis.MVREG.set("thermostat", 68)

{:ok, value} = connection |> Jylis.MVREG.get("thermostat")
# {:ok, ["68"]}
```

### UJSON

Unordered JSON <sup>[[link](https://jemc.github.io/jylis/docs/types/ujson/)]</sup>

```elixir
{:ok, _} = connection |> Jylis.UJSON.set(["users", "alice"], %{admin: false})
{:ok, _} = connection |> Jylis.UJSON.set(["users", "brett"], %{admin: false})
{:ok, _} = connection |> Jylis.UJSON.set(["users", "carol"], %{admin: true})

{:ok, users} = connection |> Jylis.UJSON.get("users")
# {:ok,
#  %{
#    "alice" => %{"admin" => false},
#    "brett" => %{"admin" => false},
#    "carol" => %{"admin" => true}
#  }}

{:ok, _} = connection |> Jylis.UJSON.ins(["users", "brett", "banned"], true)

{:ok, _} = connection |> Jylis.UJSON.clr(["users", "alice"])

{:ok, users} = connection |> Jylis.UJSON.get("users")
# {:ok,
#  %{
#    "brett" => %{"admin" => false, "banned" => true},
#    "carol" => %{"admin" => true}
#  }}
```
