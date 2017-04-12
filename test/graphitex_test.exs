defmodule GraphitexTest do
  use ExUnit.Case
  doctest Graphitex

  test "collect metric" do
    assert :ok == Graphitex.metric(4, "aws.node1.avg_cpu")
  end

  test "send batch" do
    1..10
    |> Enum.map(fn n ->
      :ok = Graphitex.metric(n, "aws.node1.load")
    end)
  end
end
