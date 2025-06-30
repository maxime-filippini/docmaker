defmodule Docmaker.MixProject do
  use Mix.Project

  def project do
    [
      app: :docmaker,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Docmaker.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nx, "~> 0.9"},
      {:vega_lite, "~> 0.1.11"},
      {:vega_lite_convert, "~> 1.0"},
      {:chromic_pdf, "~> 1.17"},
      {:phoenix_live_view, "~> 1.0"},
      {:gen_stage, "~> 1.0"},
      {:file_system, "~> 1.1"},
      {:tailwind, "~> 0.3", only: :dev}
    ]
  end
end
