defmodule LinearAlgebraTest.Matrix.VectorSpaceTest do
  use ExUnit.Case

  use LinearAlgebra

  @base_matrix ~M[1.0 4.0
                  2.0 5.0
                  3.0 6.0]

  @double_matrix ~M[2.0 8.0
                    4.0 10.0
                    6.0 12.0]

  describe "for Matrix with native backend, the math operation" do
    test "basic matrix addition works" do
      assert @double_matrix == @base_matrix + @base_matrix
    end

    test "basic matrix subtraction works" do
      assert @base_matrix == @double_matrix - @base_matrix
    end

    test "basic matrix scalar division works" do
      assert @base_matrix == @double_matrix / 2
      assert @base_matrix == @double_matrix / 2.0
    end

    test "basic matrix scalar multiplication works" do
      assert @double_matrix == 2 * @base_matrix
      assert @double_matrix == @base_matrix * 2

      assert @double_matrix == 2.0 * @base_matrix
      assert @double_matrix == @base_matrix * 2.0
    end

    test "basic matrix-vector multiplication works" do
       assert ~V[9.0, 12.0, 15.0] == @base_matrix * ~V[1.0, 2.0]
    end

    test "basic matrix-matrix multiplication works" do
      rhs = ~M[1.0 3.0 5.0
               2.0 4.0 6.0]

      res = ~M[ 9.0 19.0 29.0
               12.0 26.0 40.0
               15.0 33.0 51.0]

      assert res == @base_matrix * rhs
    end
  end
end
