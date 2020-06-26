defmodule LinearAlgebra.Adjoint do

  alias LinearAlgebra.Tensor

  @enforce_keys Tensor.keys()
  defstruct @enforce_keys

  @behaviour Access
  @behaviour Tensor.Api

  @type t :: %__MODULE__{
    dims: tuple(),
    data: LinearAlgebra.Tensor.t
  }

  ##################################################################
  ## ACCESS PROTOCOL

  @impl Access
  def fetch(%{data: data = %child_mod{}}, key) when is_integer(key) do
    child_mod.fetch(data, key)
  end
  # verify that a vector should have singleton dimensions
  def fetch(%{data: data = %child_mod{dims: {_}}}, {0, idx}) do
    child_mod.fetch(data, {idx})
  end
  def fetch(%{data: data = %child_mod{dims: {_, _}}}, {idx_1, idx_2}) do
    child_mod.fetch(data, {idx_2, idx_1})
  end

end

defimpl VectorSpace, for: LinearAlgebra.Adjoint do
  import Kernel, except: [+: 2, *: 2]

  alias LinearAlgebra.Adjoint

  def %{dims: dim, data: v1} + %Adjoint{dims: dim, data: v2} do
    %Adjoint{dims: dim, data: VectorSpace.+(v1, v2)}
  end

  def %Adjoint{dims: {1, dim}, data: v1} * (v2 = %{dims: {dim}}) do
    v1
    |> Enum.zip(v2)
    |> Enum.reduce(fn
      # we are using reduce/2 because we want this function to be agnostic
      # of the inner contents of the adjoint list (this way it could be literally)
      # anything (including a vector space, internally.)
      #
      # intercepting a tuple as the first reduction parameter selectively
      # traps this case (see the documentation for Enum.reduce/2 vs Enum.reduce/3)
      # to understand why this is done.
      {a, b}, {c, d} ->
        VectorSpace.+(
          VectorSpace.*(c, d),
          VectorSpace.*(a, b))
      # this is the general reduction case.
      {a, b}, c ->
        a
        |> VectorSpace.*(b)
        |> VectorSpace.+(c)
    end)
  end
end

defimpl Enumerable, for: LinearAlgebra.Adjoint do
  def count(%{data: data}), do: {:ok, Enum.count(data)}
  def member?(%{data: data}, what), do: {:ok, what in data}

  def reduce(%{data: data = %child_module{}}, acc, fun) do
    Module.concat(Enumerable, child_module).reduce(data, acc, fun)
  end

  def slice(_), do: {:error, __MODULE__}
end
