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
