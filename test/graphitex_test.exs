defmodule GraphitexTest do
  use ExUnit.Case
  doctest Graphitex

  test "collect metric" do
    assert :ok == Graphitex.metric(4, "aws.node1.avg_cpu")
  end

  test "collect metric atom tags" do
    assert :ok == Graphitex.metric(4, [:aws, :node1, :avg_cpu])
  end

  test "batch send" do
    batch = [
      {4, "client.transactions.east"},
      {2, "client.transactions.west"},
      {5, "client.transactions.north"}
    ]
    assert :ok ==  Graphitex.metric_batch(batch)
  end

  test "stream batch" do
    1..10
    |> Enum.map(fn n ->
      :ok = Graphitex.metric(n, "aws.node1.load")
    end)
  end
end
