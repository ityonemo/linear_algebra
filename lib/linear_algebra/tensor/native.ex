defmodule LinearAlgebra.Tensor.Native do

  alias LinearAlgebra.Tensor
  alias LinearAlgebra.Adjoint

  @enforce_keys Tensor.keys()
  defstruct @enforce_keys

  @type t :: %__MODULE__{
    dims: tuple(),
    data: [VectorSpace.t]
  }

  @behaviour Access
  @behaviour Tensor.Api

  @impl Tensor.Api
  def from_list(list, dims) do
    %__MODULE__{
      dims: dims,
      data: list
    }
  end

  @impl Tensor.Api
  def from_list(list, dims, opts) do
    if opts[:validate] do
      (dims |> Tuple.to_list |> Enum.reduce(1, &Kernel.*/2) == length(list))
        or raise "bad dimensions"
    end
    from_list(list, dims)
  end

  def split(tensor = %{dims: dims}, :first) do
    inner_dim = elem(dims, 0)
    outer_dims = dims |> Tuple.delete_at(0) |> Tuple.insert_at(0, 1)
    sub_lists = Enum.chunk_every(tensor.data, inner_dim)
    %Tensor.Native{
      dims: outer_dims,
      data: Enum.map(sub_lists,
        &(%Tensor.Native{dims: {inner_dim}, data: &1}))
    }
  end
  def split(tensor = %{dims: dims}, :last) do
    full_size = dims |> Tuple.to_list |> Enum.reduce(1, &Kernel.*/2)
    last_dim = tuple_size(dims) - 1
    inner_dim = elem(dims, last_dim)
    outer_dims = dims |> Tuple.delete_at(last_dim) |> Tuple.append(1)

    sub_lists = tensor.data
    |> Enum.with_index
    |> Enum.group_by(fn {_, idx} -> rem(idx, div(full_size, inner_dim)) end)
    |> Map.values

    %Tensor.Native{
      dims: outer_dims,
      data: Enum.map(sub_lists, &(%Adjoint{
        dims: {1, inner_dim},
        data: %Tensor.Native{
          dims: {inner_dim},
          data: strip_indices(&1)
        }}))}
  end
  defp strip_indices(lst) do
    Enum.map(lst, fn {data, _} -> data end)
  end

  ##################################################################
  ## ACCESS PROTOCOL

  @impl Access
  def fetch(tensor, key) when is_integer(key) do
    if key <= prod(tensor.dims) do
      {:ok, Enum.at(tensor.data, key)}
    else
      :error
    end
  end
  def fetch(tensor = %{dims: dims}, key) when is_tuple(key) and
    tuple_size(key) == tuple_size(dims) do
    with {:ok, idx} <- to_idx(key, dims) do
      {:ok, Enum.at(tensor.data, idx)}
    end
  end

  @impl Access
  def get_and_update(_, _, _), do: raise "mutating functions are not implemented yet."

  @impl Access
  def pop(_, _), do: raise "mutating functions are not implemented yet."

  defp to_idx({singleton}, {dim}) when singleton < dim, do: {:ok, singleton}
  defp to_idx({idx_1, idx_2}, {mtx_1, mtx_2}) when
      idx_1 < mtx_1 and idx_2 < mtx_2 do
    {:ok, mtx_1 * idx_2 + idx_1}
  end
  defp to_idx(_, _), do: :error

  # fast versions
  defp prod({singleton}), do: singleton
  defp prod({mtx_1, mtx_2}), do: mtx_1 * mtx_2
  defp prod(tuple) do
    tuple
    |> Tuple.to_list
    |> Enum.reduce(&VectorSpace.*/2)
  end

  ###################################################################
  ## helpful procs

  def flat_product(list1, list2) do
    Enum.flat_map(list2, &bcast_prod(&1, list1))
  end
  defp bcast_prod(elem, lst) do
    Enum.map(lst, &(VectorSpace.*(&1, elem)))
  end

end

defimpl Enumerable, for: LinearAlgebra.Tensor.Native do
  def count(%{dims: {singleton}}), do: singleton
  def count(%{dims: {mtx_a, mtx_b}}), do: mtx_a * mtx_b
  def count(%{dims: dims}), do: dims |> Tuple.to_list |> Enum.reduce(1, &(&1 * &2))

  def member?(%{data: data}, what), do: {:ok, what in data}

  def reduce(%{data: data}, acc, fun), do: Enumerable.List.reduce(data, acc, fun)

  def slice(_), do: {:error, __MODULE__}
end


defimpl VectorSpace, for: LinearAlgebra.Tensor.Native do

  import Kernel, except: [+: 2, -: 2, *: 2, "/": 2]
  import LinearAlgebra

  alias LinearAlgebra.Tensor.Native
  alias LinearAlgebra.Adjoint

  def %{dims: dim, data: v1} + %{dims: dim, data: v2} do
    %Native{
      dims: dim,
      data: v1 |> Stream.zip(v2) |> Enum.map(fn {a, b} -> Kernel.+(a, b) end)
    }
  end

  def %{dims: dim, data: v1} - %{dims: dim, data: v2} do
    %Native{
      dims: dim,
      data: v1 |> Stream.zip(v2) |> Enum.map(fn {a, b} -> Kernel.-(a, b) end)
    }
  end

  def vector * value when is_scalar(value) do
    %{vector | data: Enum.map(vector.data, &VectorSpace.*(&1, value))}
  end

  # special case: adjoint vector outer product.  Promote the vector to an
  # nx1 matrix
  def (vector = %{dims: {singleton}}) * (adjoint = %{dims: adj_dims})
      when elem(adj_dims, 0) == 1 do
    %{vector | dims: {singleton, 1}} * adjoint
  end

  def (t1 = %{dims: d1}) * (t2 = %{dims: d2})
      when elem(d1, Kernel.-(tuple_size(d1), 1)) == elem(d2, 0) do
    # trailing dimension is 1 and leading dimension of second
    # tensor is 2.
    if elem(d2, 0) == 1 do
      %Native{
        dims: concat(d1, d2),
        data: Native.flat_product(t1.data, t2.data)
      }
    else
      Native.split(t1, :last) * Native.split(t2, :first)
    end
  end

  def vector / value when is_scalar(value) do
    %{vector | data: Enum.map(vector.data, &VectorSpace./(&1, value))}
  end

  defp concat(d1, d2) do
    [Tuple.delete_at(d1, Kernel.-(tuple_size(d1), 1)), Tuple.delete_at(d2, 0)]
    |> Enum.flat_map(&Tuple.to_list/1)
    |> List.to_tuple
  end

  def adj(vector = %{dims: {singleton}}) do
    %Adjoint{dims: {1, singleton}, data: vector}
  end
  def adj(matrix = %{dims: {rows, cols}}) do
    %Adjoint{dims: {cols, rows}, data: matrix}
  end
end
