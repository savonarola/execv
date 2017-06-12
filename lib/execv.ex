defmodule Execv do
  @moduledoc false

  @exec_so_content File.read!("priv/exec.so")
  @stty_opts "echo opost"

  @on_load :load_nifs

  def generate_exec_so_basepath do
    "/tmp/#{:rand.uniform(9999999)}.#{:os.system_time(:nano_seconds)}.exec"
  end

  def load_nifs do
    exec_so_basepath = generate_exec_so_basepath()
    exec_so_path = exec_so_basepath <> ".so"
    File.write!(exec_so_path, @exec_so_content)
    :erlang.load_nif(exec_so_basepath, 0)
    File.rm!(exec_so_path)
  end

  def exec(args, stty_opts \\ @stty_opts) when is_list(args) and is_binary(stty_opts) do
    erl_stty_opts = to_charlist(stty_opts)
    erl_args = Enum.map(args, &to_charlist/1)
    case do_exec(erl_args, erl_stty_opts) do
      {:error, desc} when is_list(desc) -> {:error, to_string(desc)}
      other -> other
    end
  end

  def do_exec(_args, _stty_opts) do
    raise "NIF do_exec/2 not implemented"
  end

end
