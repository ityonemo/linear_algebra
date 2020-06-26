defmodule LinearAlgebraTest.Matrix.EnumerableTest do
    use ExUnit.Case, async: true

  use LinearAlgebra

  @base_matrix ~M[1.0 4.0
                  2.0 5.0
                  3.0 6.0]

  test "enumeration works as column-major" do
    assert Enum.to_list(@base_matrix) == [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
  end

  test "access functionality works as expected" do
    assert @base_matrix[0] == 1.0
    assert @base_matrix[1] == 2.0
    assert @base_matrix[3] == 4.0

    assert @base_matrix[{0, 0}] == 1.0
    assert @base_matrix[{1, 0}] == 2.0
    assert @base_matrix[{0, 1}] == 4.0
  end
end
