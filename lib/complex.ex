defmodule Complex do
  @enforce_keys [:re, :im]
  defstruct @enforce_keys

  @type t(type) :: %Complex{
    re: type,
    im: type
  }

  @type t :: t(float) | t(integer)

  defguard is_complex(value) when :erlang.map_get(:__struct__, value) == Complex
  defguard is_real(value) when is_float(value) or is_integer(value)

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
  def (a = %{re: a_re, im: a_im}) / (b = %{re: b_re, im: b_im}) when
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

  def a * b when is_real(a) do
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
  def a * b when is_tensor(a) do
    b * a
  end

  # the adjoint of a complex number is its complex conjugate
  def adj(src) do
    %Complex{re: src.re, im: VectorSpace.-(src.im)}
  end
end
