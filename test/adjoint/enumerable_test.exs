defmodule LinearAlgebraTest.Adjoint.EnumerableTest do
  use ExUnit.Case

  use LinearAlgebra

  @adj_vector adj(~V"1.0, 2.0, 3.0")

  @adj_matrix adj(~M"""
  1.0 4.0
  2.0 5.0
  3.0 6.0
  """)

  describe "for Vectors" do
    test "enumerating the adjoint is as normal" do
      assert Enum.to_list(@adj_vector) == [1.0, 2.0, 3.0]
    end

    test "raw access functionality is as normal" do
      assert @adj_vector[0] == 1.0
      assert @adj_vector[1] == 2.0
    end

    test "indexed access functionality is also as expected" do
      assert @adj_vector[{0, 0}] == 1.0
      assert @adj_vector[{0, 1}] == 2.0
    end
  end

  describe "for Matrices" do
    test "enumerating the adjoint perserves the parent structure" do
      assert Enum.to_list(@adj_matrix) == [
        1.0, 2.0, 3.0, 4.0, 5.0, 6.0
      ]
    end

    test "raw access functionality preserves parent structure" do
      assert @adj_matrix[0] == 1.0
      assert @adj_matrix[1] == 2.0
      assert @adj_matrix[3] == 4.0
    end

    test "indexed access functionality is transposed" do
      assert @adj_matrix[{0, 0}] == 1.0
      assert @adj_matrix[{0, 1}] == 2.0
      assert @adj_matrix[{1, 0}] == 4.0
    end
  end
end
