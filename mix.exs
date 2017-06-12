defmodule Mix.Tasks.Compile.Execv do
  def run(_args) do
    {result, _errcode} = System.cmd("make", [], stderr_to_stdout: true)
    IO.binwrite(result)
  end
end

defmodule Execv.Mixfile do
  use Mix.Project

  def project do
    [
      app: :execv,
      compilers: [:execv] ++ Mix.compilers,
      version: "0.1.0",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    []
  end
end
