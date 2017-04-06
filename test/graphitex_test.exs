defmodule GraphitexTest do
  use ExUnit.Case
  doctest Graphitex

  test "collect metric" do
    assert :ok == Graphitex.metric(4, "foo.bar")
  end

  test "send batch" do
    1..10_000
    |> Enum.map(fn n ->
      :ok = Graphitex.metric(n, "doit.now")
    end)
  end
end
