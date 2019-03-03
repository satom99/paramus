defmodule Paramus.MixProject do
  use Mix.Project

  def project do
    [
      app: :paramus,
      version: "1.0.0",
      elixir: "~> 1.2",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: "Parameter validation for Phoenix.",
      package: package(),
      deps: deps()
    ]
  end

  defp deps do
    [
      {:ecto, ">= 2.0.0"},
      {:phoenix, ">= 0.6.0"}
    ]
  end

  defp package do
    [
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/satom99/paramus"}
    ]
  end
end
