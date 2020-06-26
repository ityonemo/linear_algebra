defmodule VectorSpaceTest do
    use ExUnit.Case, async: true, async: true

  use LinearAlgebra

  describe "for standard integers" do
    test "addition is undisrupted" do
      assert 1 + 1 == 2
    end
    test "subtraction is undisrupted" do
      assert 1 - 1 == 0
    end
    test "multiplication is undisrupted" do
      assert 1 * 1 == 1
    end
    test "division is undisrupted" do
      assert 1 / 1 == 1.0
    end
  end

  describe "for standard floats" do
    test "addition is undisrupted" do
      assert 1.0 + 1.0 == 2.0
    end
    test "subtraction is undisrupted" do
      assert 1.0 - 1.0 == 0.0
    end
    test "multiplication is undisrupted" do
      assert 1.0 * 1.0 == 1.0
    end
    test "division is undisrupted" do
      assert 1.0 / 1.0 == 1.0
    end
  end

  describe "there is support for aggregations" do
    test "over addition" do
      assert 6.0 == Enum.reduce([1.0, 2.0, 3.0], &VectorSpace.+/2)
    end
    test "over multiplication" do
      assert 6.0 == Enum.reduce([1.0, 2.0, 3.0], &VectorSpace.*/2)
    end
  end
end
