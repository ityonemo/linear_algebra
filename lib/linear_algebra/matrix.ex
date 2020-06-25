defmodule LinearAlgebra.Matrix do

  @type t :: %{
    __struct__: module(),
    dims: {non_neg_integer(), non_neg_integer()},
    data: any()
  }

  @tensor Application.compile_env(:linear_algebra, :tensor_module, LinearAlgebra.Tensor.Native)

  defmacro sigil_M({:<<>>, _, [content]}, 't') do
    content
    |> to_matrix
    |> VectorSpace.adj
    |> Macro.escape
  end
  defmacro sigil_M({:<<>>, _, [content]}, _) do
    content
    |> to_matrix
    |> Macro.escape
  end

  defmacro from_list(list, dims) do
    list
    |> @tensor.from_list(dims, validate: true)
    |> Macro.escape
  end

  defp to_matrix(content) do
    transpose = content
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn row ->
      row
      |> String.split
      |> Enum.map(&String.to_float/1)
    end)

    rows = length(transpose)
    cols = length(hd(transpose))

    transpose
    |> Enum.zip
    |> Enum.flat_map(&Tuple.to_list/1)
    |> @tensor.from_list({rows, cols}, validate: true)
  end
end
