defmodule Paramus.MixProject do
  use Mix.Project

  def project do
    [
      app: :paramus,
      version: "0.1.0",
      elixir: "~> 1.2",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp deps do
    [
      {:ecto, ">= 2.0.0"},
      {:phoenix, ">= 0.6.0"}
    ]
  end
end
