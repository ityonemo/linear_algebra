defmodule LinearAlgebraTest.Complex.LiteralsTest do
  use ExUnit.Case, async: true
  use LinearAlgebra

  describe "for Complex numbers" do
    test "basic literals works" do
      assert %{re: 1.0, im: 1.0} = ~C(1.0 + 1.0i)
      assert %{re: 1.0, im: -1.0} = ~C(1.0 - 1.0i)
      assert %{re: -1.0, im: 1.0} = ~C(-1.0 + 1.0i)
      assert %{re: -1.0, im: -1.0} = ~C(-1.0 - 1.0i)
    end

    test "degenerate literals works" do
      assert %{re: 1.0, im: 0.0} = ~C(1.0)
      assert %{re: -1.0, im: 0.0} = ~C(-1.0)
      assert %{re: 0.0, im: 1.0} = ~C(1.0i)
      assert %{re: 0.0, im: -1.0} = ~C(-1.0i)
    end
  end
end
