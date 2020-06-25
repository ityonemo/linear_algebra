defmodule LinearAlgebra.Vector do
  @type t :: %{
    __struct__: module(),
    dims: {non_neg_integer()},
    data: any()
  }

  @tensor Application.compile_env(:linear_algebra, :tensor_module, LinearAlgebra.Tensor.Native)

  defmacro sigil_V({:<<>>, _, [content]}, modifier) do
    if String.contains?(content, ",") do
      content
      |> String.split(",")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.to_float/1)
    else
      content
      |> String.trim
      |> String.split("\n")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.to_float/1)
    end
    |> do_from_list(modifier)
  end

  defmacro from_list(lst), do: do_from_list(lst)

  defp do_from_list(lst, modifier \\ false) do
    lst
    |> @tensor.from_list({length(lst)}, validate: true)
    |> adj(modifier == 't')
    |> Macro.escape
  end

  defp adj(vector, true), do: VectorSpace.adj(vector)
  defp adj(vector, _), do: vector
end
