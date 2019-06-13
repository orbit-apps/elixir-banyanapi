defmodule BanyanApiTest do
  use ExUnit.Case
  doctest BanyanApi

  test "greets the world" do
    assert BanyanApi.hello() == :world
  end
end
