defmodule LinearAlgebra do
  defmacro __using__(_) do
    quote do
      alias LinearAlgebra.{Vector, Matrix, Adjoint}
      import Kernel, except: [+: 2, *: 2, -: 2, "/": 2]
      import VectorSpace
      import Vector
      import Matrix
      import Complex
      import LinearAlgebra
    end
  end

  require Complex

  defguard is_scalar(value) when is_number(value) or Complex.is_complex(value)

end
