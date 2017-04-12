# Graphitex

Graphite client for Elixir with zero dependencies


[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/msoedov/graphitex/blob/master/LICENSE)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/msoedov/graphitex.svg)](https://beta.hexfaktor.org/github/msoedov/graphitex)
[![Inline docs](https://inch-ci.org/github/msoedov/graphitex.svg?branch=master)](https://inch-ci.org/github/msoedov/graphitex) [![Hex Version](https://img.shields.io/hexpm/v/graphitex.svg)](https://hex.pm/packages/graphitex)



## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `graphitex` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:graphitex, "~> 0.1.0"}]
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
  Graphitex.metric(4, "aws.node1.avg_cpu")
  # or
  Graphitex.metric(4, ["aws", "node1", "avg_cpu"])
  # or
  Graphitex.metric(41.0, [:aws, :node1, :avg_cpu])
  ```

  by default `:os.system_time(:seconds)` used as timestamp, but you can pass ts as an argument

  ```elixir
  Graphitex.metric(41, "aws.node1.avg_cpu",:os.system_time(:seconds))

  ```
  likewise there is a shortcut

  ```elixir
  Graphitex.metric(41, "aws.node1.avg_cpu", Graphitex.now)

  ```

  Insert batch:
  ```elixir
  [{4, "client.transactions.east"},
    {2, "client.transactions.west"},
    {5, "client.transactions.north", Graphitex.now}
  ]
  |> Graphitex.metric_batch(batch)

  ```
