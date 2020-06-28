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

  @spec left_scalar_multiply(t, scalar) :: t
  def left_scalar_multiply(t, scalar)
end

# VectorSpace protocol implementations for builtin types

defimpl VectorSpace, for: Integer do
  import Kernel, except: [+: 2, *: 2, -: 2, "/": 2]
  import Complex

  def a + b, do: Kernel.+(a, b)
  def a - b, do: Kernel.-(a, b)
  def a / b, do: Kernel./(a, b)

  # multiplication is polymorphic, because it's commutative
  # across scalar multiplication.
  def a * b when is_number(b), do: Kernel.*(b, a)
  def a * b when is_complex(b), do: VectorSpace.*(b, a)
  def a * b, do: VectorSpace.left_scalar_multiply(b, a)

  # the adjoint of an integer is itself.
  def adj(integer), do: integer

  def left_scalar_multiply(integer, scalar), do: scalar * integer
end

defimpl VectorSpace, for: Float do
  import Kernel, except: [+: 2, *: 2, -: 2, "/": 2]
  import Complex

  def a + b, do: Kernel.+(a, b)
  def a - b, do: Kernel.-(a, b)
  def a / b, do: Kernel./(a, b)

  # multiplication is polymorphic, because it's commutative
  # across scalar multiplication.
  def a * b when is_number(b), do: Kernel.*(a, b)
  def a * b when is_complex(b), do: VectorSpace.*(b, a)
  def a * b, do: VectorSpace.left_scalar_multiply(b, a)

  # the adjoint of a float is itself
  def adj(float), do: float

  def left_scalar_multiply(float, scalar), do: scalar * float
end
