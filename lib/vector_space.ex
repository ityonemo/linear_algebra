defprotocol VectorSpace do

  @type scalar :: Complex.t | number
  @type t :: Tensor.t | scalar

  @spec t + t :: t
  def a + b
  @spec t - t :: t
  def a - b
  @spec t * scalar :: t
  def a * b
  @spec t / scalar :: t
  def a / b

  @spec adj(t) :: t
  def adj(t)
end

# VectorSpace protocol implementations for builtin types

defimpl VectorSpace, for: Integer do
  import Kernel, except: [+: 2, *: 2, -: 2, "/": 2]
  import LinearAlgebra.Tensor

  def a + b, do: Kernel.+(a, b)
  def a - b, do: Kernel.-(a, b)
  def a / b, do: Kernel./(a, b)

  # multiplication is polymorphic, because it's commutative
  # across scalar multiplication.
  def a * b when is_tensor(b), do: VectorSpace.*(b, a)
  def a * b, do: Kernel.*(a, b)

  # the adjoint of an integer is itself.
  def adj(integer), do: integer
end

defimpl VectorSpace, for: Float do
  import Kernel, except: [+: 2, *: 2, -: 2, "/": 2]
  import LinearAlgebra.Tensor

  def a + b, do: Kernel.+(a, b)
  def a - b, do: Kernel.-(a, b)
  def a / b, do: Kernel./(a, b)

  # multiplication is polymorphic, because it's commutative
  # across scalar multiplication.
  def a * b when is_tensor(b), do: VectorSpace.*(b, a)
  def a * b, do: Kernel.*(a, b)

  # the adjoint of a float is itself
  def adj(float), do: float
end
