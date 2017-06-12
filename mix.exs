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
      description: "Elixir interface to exec system call",
      version: "0.1.2",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      package: package(),
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [{:ex_doc, "~> 0.14", only: :dev, runtime: false}]
  end

  defp package do
    [
      name: :execv,
      files: ["lib", "mix.exs", "README*", "LICENSE", "Makefile", "c_src"],
      maintainers: ["Ilya Averyanov"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/savonarola/execv"
      }
    ]
  end

end
