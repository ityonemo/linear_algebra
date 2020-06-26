defmodule LinearAlgebraTest.Adjoint.LiteralsTest do
    use ExUnit.Case, async: true

  use LinearAlgebra

  describe "for a Vector literal" do
    test "the adjoint can be created with the t suffix" do
      adjoint_literal = ~V[1.0, 2.0, 3.0]t

      assert %Adjoint{
        dims: {1, 3},
        data: ~V[1.0, 2.0, 3.0]
      } = adjoint_literal
    end
  end

  describe "for a Matrix literal" do
    test "the adjoint can be created with the t suffix" do
      adjoint_literal = ~M[1.0 4.0
                           2.0 5.0
                           3.0 6.0]t

      assert %Adjoint{
        dims: {2, 3},
        data: ~M[1.0 4.0
                 2.0 5.0
                 3.0 6.0]
      } = adjoint_literal
    end
  end
end
