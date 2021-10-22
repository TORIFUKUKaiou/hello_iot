defmodule HelloIotTest do
  use ExUnit.Case
  doctest HelloIot

  test "greets the world" do
    assert HelloIot.hello() == :world
  end
end
