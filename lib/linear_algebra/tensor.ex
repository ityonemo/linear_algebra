defmodule LinearAlgebra.Tensor do
  @type t :: %{
    __struct__: module(),
    dims: tuple(),
    data: any()
  }

  defguard is_tensor(value) when is_struct(value) and
    is_tuple(:erlang.map_get(:dims, value)) and
    is_map_key(value, :data)

  def keys, do: [:dims, :data]
end
