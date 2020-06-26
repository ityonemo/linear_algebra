defmodule LinearAlgebraTest.Vector.LiteralsTest do
    use ExUnit.Case, async: true

  use LinearAlgebra

  describe "for Vector with native backend defining values" do
    test "with basic vector works" do
      assert %{dims: {3}, data: [1.0, 2.0, 3.0]} = ~V[1.0
                                                      2.0
                                                      3.0]

      assert %{dims: {3}, data: [1.0, 2.0, 3.0]} = ~V[1.0, 2.0, 3.0]

      assert %{dims: {3}, data: [1.0, 2.0, 3.0]} = Vector.from_list([1.0, 2.0, 3.0])
    end
  end
end
