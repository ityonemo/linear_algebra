defmodule LinearAlgebraTest.Complex.VectorSpaceTest do
  use ExUnit.Case, async: true
  use LinearAlgebra

  @single ~C(1.0 + 1.0i)
  @double ~C(2.0 + 2.0i)

  describe "for Complex numbers the math operation" do
    test "basic complex addition works" do
      assert @double == @single + @single
    end

    test "basic complex subtraction works" do
      assert @single == @double - @single
    end

    test "basic complex scalar division works" do
      assert @single == @double / 2
      assert @single == @double / 2.0
    end

    test "basic complex scalar multiplication works" do
      assert @double == 2 * @single
      assert @double == @single * 2

      assert @double == 2.0 * @single
      assert @double == @single * 2.0
    end
  end
end
