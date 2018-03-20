# Graphitex

Graphite client for Elixir with zero dependencies


[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/msoedov/graphitex/blob/master/LICENSE)
[![Hex Version](https://img.shields.io/hexpm/v/graphitex.svg)](https://hex.pm/packages/graphitex)
[![Build Status](https://travis-ci.org/msoedov/graphitex.svg?branch=master)](https://travis-ci.org/msoedov/graphitex)



## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `graphitex` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:graphitex, "~> 0.3.0"}]
  end
  ```

  2. Ensure `graphitex` is started before your application:

  ```elixir
  def application do
    [applications: [:graphitex]]
  end

  ```
  3. Set up configuration in `config.config.exs`:

  ```elixir
  config :graphitex, host: '188.166.101.102', port: 2003

  ```
  4. API:

  ```elixir
  Graphitex.metric(4, "aws.cluster_one.avg_cpu")
  # or
  Graphitex.metric(4, ["aws", "cluster_one", "avg_cpu"])
  # or
  Graphitex.metric(41.0, [:aws, :cluster_one, :avg_cpu])
  ```

  by default `:os.system_time(:seconds)` used as timestamp, but you can pass `ts` as an argument

  ```elixir
  Graphitex.metric(41, "aws.cluster_one.avg_cpu",:os.system_time(:seconds))

  ```
  likewise there is a shortcut

  ```elixir
  Graphitex.metric(41, "aws.cluster_one.avg_cpu", Graphitex.now)

  ```

  Insert batch:
  ```elixir
   [{4, "client.transactions.east"},
    {2, "client.transactions.west"},
    {5, "client.transactions.north", Graphitex.now}
   ]
  |> Graphitex.metric_batch(batch)

  ```
