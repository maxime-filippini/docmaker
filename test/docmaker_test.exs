defmodule DocmakerTest do
  use ExUnit.Case
  doctest Docmaker

  test "greets the world" do
    assert Docmaker.hello() == :world
  end
end
