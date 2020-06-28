defmodule LinearAlgebra do
  defmacro __using__(_) do
    quote do
      alias LinearAlgebra.{Vector, Matrix, Adjoint}

      # note we're taking over sigil_C for complex numbers.
      import Kernel, except: [+: 2, *: 2, -: 2, "/": 2, sigil_C: 2]
      import VectorSpace, except: [left_scalar_multiply: 2]
      import Vector, only: [sigil_V: 2]
      import Matrix, only: [sigil_M: 2]
      import Complex, only: [is_complex: 1, is_real: 1, sigil_C: 2]
      import Adjoint, only: [is_adjoint: 1]
      import LinearAlgebra
    end
  end

  require Complex

  defguard is_scalar(value) when is_number(value) or Complex.is_complex(value)

end
