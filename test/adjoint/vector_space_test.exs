#defmodule LinearAlgebraTest.Matrix.VectorSpaceTest do
#  use ExUnit.Case
#
#  use LinearAlgebra
#
#  describe "for Vector with native backend, the math operation" do
#    test "basic matrix addition works" do
#      a = ~M"""
#            1.0 4.0
#            2.0 5.0
#            3.0 6.0
#            """
#      b = ~M"""
#            2.0 8.0
#            4.0 10.0
#            6.0 12.0
#            """
#      assert b == a + a
#    end
#
#    test "basic matrix subtraction works" do
#      a = ~M"""
#            1.0 4.0
#            2.0 5.0
#            3.0 6.0
#            """
#      b = ~M"""
#            2.0 8.0
#            4.0 10.0
#            6.0 12.0
#            """
#      assert a == b - a
#    end
#
#    test "basic matrix scalar division works" do
#      a = ~M"""
#            1.0 4.0
#            2.0 5.0
#            3.0 6.0
#            """
#      b = ~M"""
#            2.0 8.0
#            4.0 10.0
#            6.0 12.0
#            """
#      assert a == b / 2
#      assert a == b / 2.0
#    end
#
#    test "basic matrix scalar multiplication works" do
#      a = ~M"""
#            1.0 4.0
#            2.0 5.0
#            3.0 6.0
#            """
#      b = ~M"""
#            2.0 8.0
#            4.0 10.0
#            6.0 12.0
#            """
#      assert b == 2 * a
#      assert b == a * 2
#
#      assert b == 2.0 * a
#      assert b == a * 2.0
#    end
#
#    test "basic matrix-vector multiplication works" do
#      m = ~M"""
#        1.0 2.0
#        3.0 4.0
#        5.0 6.0
#      """
#
#      v = ~V"1.0, 2.0"
#
#      res = ~V"5.0, 11.0, 17.0"
#
#      assert res == m * v
#    end
#
#    test "basic matrix-matrix multiplication works" do
#      m = ~M"""
#        1.0 2.0
#        3.0 4.0
#        5.0 6.0
#      """
#
#      v = ~M"""
#        1.0 3.0 5.0
#        2.0 4.0 6.0
#      """
#
#      res = ~M"""
#         5.0 11.0 17.0
#        11.0 25.0 39.0
#        17.0 39.0 61.0
#      """
#
#      assert res == m * v
#    end
#  end
#end
#
