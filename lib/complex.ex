defmodule Complex do
  @enforce_keys [:re, :im]
  defstruct @enforce_keys

  @type t(type) :: %Complex{
    re: type,
    im: type
  }

  @type t :: t(float) | t(integer)

  @compile inline: [i: 0, i: 1]
  def i(), do: %__MODULE__{re: 0, im: 1}
  def i(:integer), do: %__MODULE__{re: 0.0, im: 1.0}
  def i(:float), do: %__MODULE__{re: 0.0, im: 1.0}

  defguard is_complex(value) when :erlang.map_get(:__struct__, value) == Complex
  defguard is_real(value) when is_number(value)

  @signs [?-, ?+]
  def parse(content) do
    with {re, rest!} <- Float.parse(content),
         {:re, _, <<s>> <> rest!} when s in @signs <- {:re, re, String.trim(rest!)},
         {im, "i" <> rest!} <- rest! |> String.trim |> Float.parse do
      case s do
        ?- -> {%Complex{re: re, im: -im}, rest!}
        ?+ -> {%Complex{re: re, im: im}, rest!}
      end
    else
      {:re, im, "i" <> rest} ->
        {%Complex{re: 0.0, im: im}, rest}
      {:re, re, rest} ->
        {%Complex{re: re, im: 0.0}, rest}
      _ -> :error
    end
  end


  @doc """
  Overrides elixir Standard library's sigil_C to emit a complex number.
  You weren't using unsusbstituted charlists anyways.
  """
  defmacro sigil_C({:<<>>, _, [content]}, _) do
    case Complex.parse(content) do
      {cplx, ""} -> Macro.escape(cplx)
      :error -> raise "invalid complex number"
    end
  end

end

defimpl VectorSpace, for: Complex do
  import Kernel, except: [+: 2, *: 2, -: 2, "/": 2]
  import LinearAlgebra.Tensor
  import Complex

  def a + b when is_real(b) do
    %{a | re: VectorSpace.+(a.re, b)}
  end
  def a + b when is_complex(b) do
    %Complex{
      re: VectorSpace.+(a.re, b.re),
      im: VectorSpace.+(a.im, b.im)
    }
  end

  def a - b when is_real(b) do
    %{a | re: VectorSpace.-(a.re, b)}
  end
  def a - b when is_complex(b) do
    %Complex{
      re: VectorSpace.-(a.re, b.re),
      im: VectorSpace.-(a.im, b.im)
    }
  end

  # TODO: division by zero check.
  def a / b when is_real(b) do
    %Complex{
      re: VectorSpace./(a.re, b),
      im: VectorSpace./(a.im, b)
    }
  end
  def (%{re: a_re, im: a_im}) / (b = %{re: b_re, im: b_im}) when
    is_complex(b) do

    b_norm = VectorSpace.+(
      VectorSpace.*(b_re, b_re),
      VectorSpace.*(b_im, b_im)
    )

    re_part = VectorSpace./(
      VectorSpace.+(VectorSpace.*(a_re, b_re), VectorSpace.*(a_im, b_im)),
      b_norm
    )

    im_part = VectorSpace./(
      VectorSpace.-(VectorSpace.*(a_im, b_re), VectorSpace.*(a_re, b_im)),
      b_norm
    )

    %Complex{re: re_part, im: im_part}
  end

  def a * b when is_real(b) do
    %Complex{
      re: VectorSpace.*(a.re, b),
      im: VectorSpace.*(a.im, b)
    }
  end
  def a * b when is_complex(b) do
    %Complex{
      re: VectorSpace.*(a.re, b),
      im: VectorSpace.*(a.im, b)
    }
  end
  def a * b when is_tensor(b) do
    b * a
  end

  # the adjoint of a complex number is its complex conjugate
  def adj(src) do
    %Complex{re: src.re, im: VectorSpace.-(src.im)}
  end

  def left_scalar_multiply(cplx, scalar) do
    %Complex{re: scalar * cplx, im: scalar * cplx}
  end
end
