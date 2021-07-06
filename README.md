NOTE: this project is now archived.  I won't be supporting it, but please feel free to fork it and work on it!


# LinearAlgebra

A Linear Algebra Library for Elixir inspired by Julia

## Objectives

- Tensors out of the box
- Support column-major tensor operations in Elixir
- Support computational backends
  - default computational backend is pure Elixir (slow!)
  - matrex library?
  - nifs via zig/C++/rust
  - Julia via distributed Julia
- Support Complex (and maybe Quaternion and Dual) numbers out of the box
- Support householder notation (see: https://www.youtube.com/watch?v=C2RO34b_oPM)
- Work towards differentiable programming
- Work towards machine learning applications

## Example:

Basic linear algebra:

```
iex> use LinearAlgebra
iex> ~M[1.0 2.0
        2.0 1.0] * ~V[1.0, 2.0]
~V[5.0, 4.0]
```

Dot product (with householder notation):
```
iex> use LinearAlgebra
iex> ~V[1.0, 2.0]t * ~V[1.0, 2.0]
5.0
```


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `linear_algebra` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:linear_algebra, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/linear_algebra](https://hexdocs.pm/linear_algebra).

