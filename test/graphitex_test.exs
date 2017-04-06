defmodule GraphitexTest do
  use ExUnit.Case
  doctest Graphitex

  test "collect metric" do
    assert :ok == Graphitex.metric(4, "foo.bar")
  end
end
