defmodule LinearAlgebraTest.Vector.EnumerableTest do
  use ExUnit.Case

  use LinearAlgebra

  describe "for Vector with native backend defining values" do
    test "enumerable is correctly implemented" do
      assert Enum.to_list(~V"1.0, 2.0, 3.0") == [1.0, 2.0, 3.0]
    end

    test "the access method works" do
      vector = ~V"1.0, 2.0, 3.0"
      assert vector[0] == 1.0
      assert vector[{1}] == 2.0
    end
  end
end
