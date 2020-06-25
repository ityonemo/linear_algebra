defmodule LinearAlgebra.Tensor.Api do
  alias LinearAlgebra.Tensor

  @callback from_list([VectorSpace.t], tuple) :: Tensor.t
  @callback from_list([VectorSpace.t], tuple, keyword) :: Tensor.t

end
