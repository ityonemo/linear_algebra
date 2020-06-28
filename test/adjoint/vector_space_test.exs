defmodule LinearAlgebraTest.Adjoint.VectorSpaceTest do
  use ExUnit.Case, async: true
  use LinearAlgebra

  @base_matrix ~M[1.0 4.0
                2.0 5.0
                3.0 6.0]t

  @double_matrix ~M[2.0 8.0
                  4.0 10.0
                  6.0 12.0]t

  describe "for Adjoint with native backend, the math operation" do
    test "basic adjoint addition works" do
      assert @double_matrix == @base_matrix + @base_matrix
    end

    test "basic adjoint subtraction works" do
      assert @base_matrix == @double_matrix - @base_matrix
    end

    test "basic adjoint scalar division works" do
      assert @base_matrix == @double_matrix / 2
      assert @base_matrix == @double_matrix / 2.0
    end

    test "basic adjoint scalar multiplication works" do
      assert @double_matrix == 2 * @base_matrix
      assert @double_matrix == @base_matrix * 2

      assert @double_matrix == 2.0 * @base_matrix
      assert @double_matrix == @base_matrix * 2.0
    end

    test "basic adjoint-vector multiplication works" do
       assert ~V[9.0, 12.0, 15.0]t == ~V[1.0, 2.0]t * @base_matrix
    end

    test "basic adjoint-matrix multiplication works" do
      rhs = ~M[1.0 3.0 5.0
               2.0 4.0 6.0]t

      res = ~M[ 9.0 19.0 29.0
               12.0 26.0 40.0
               15.0 33.0 51.0]t

      assert res == rhs * @base_matrix
    end
  end

  describe "the adjoint of an adjoint is the original" do
    test "for a vector" do
      assert ~V[1.0, 2.0, 3.0] == adj(~V[1.0, 2.0, 3.0]t)
    end

    test "for a matrix" do
      assert ~M[1.0 4.0
                2.0 5.0
                3.0 6.0] == adj(@base_matrix)
    end
  end
end
