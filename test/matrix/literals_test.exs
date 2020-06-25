defmodule LinearAlgebraTest.Matrix.LiteralsTest do
  use ExUnit.Case

  use LinearAlgebra

  describe "for Matrix with native backend defining values" do
    test "basic matrix is represented as column-major" do
      assert %{dims: {3, 2}, data:
        [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]} = ~M"""
                                            1.0 4.0
                                            2.0 5.0
                                            3.0 6.0
                                            """

      assert %{dims: {3, 2}, data: [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]} =
        Matrix.from_list([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], {3, 2})
    end
  end
end
