defmodule LinearAlgebraTest.Vector.VectorSpaceTest do
  use ExUnit.Case

  use LinearAlgebra

  describe "for Vector with native backend, the math operation" do
    test "vector addition works" do
      assert ~V"2.0, 4.0, 6.0" == ~V"1.0, 2.0, 3.0" + ~V"1.0, 2.0, 3.0"
    end

    test "vector subtraction works" do
      assert ~V"0.0, 0.0, 0.0" == ~V"1.0, 2.0, 3.0" - ~V"1.0, 2.0, 3.0"
    end

    test "scalar multiplication works" do
      assert ~V"2.0, 4.0, 6.0" == 2 * ~V"1.0, 2.0, 3.0"
      assert ~V"2.0, 4.0, 6.0" == ~V"1.0, 2.0, 3.0" * 2

      assert ~V"2.0, 4.0, 6.0" == 2.0 * ~V"1.0, 2.0, 3.0"
      assert ~V"2.0, 4.0, 6.0" == ~V"1.0, 2.0, 3.0" * 2.0
    end

    test "scalar division works" do
      assert ~V"1.0, 2.0, 3.0" == ~V"2.0, 4.0, 6.0" / 2
      assert ~V"1.0, 2.0, 3.0" == ~V"2.0, 4.0, 6.0" / 2.0
    end
  end
end
