defmodule LinearAlgebra.MixProject do
  use Mix.Project

  def project do
    [
      app: :linear_algebra,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.2", only: [:test, :dev], runtime: false},
      {:dialyxir, "~> 0.5.1", only: :dev, runtime: false},
      {:ex_doc, "~> 0.20.2", only: :dev, runtime: false},
      {:excoveralls, "~> 0.11.1", only: :test}
    ]
  end
end
