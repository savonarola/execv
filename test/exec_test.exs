defmodule ExecTest do
  use ExUnit.Case

  test "exec" do
    assert {:error, _} = Exec.exec([])
    assert {:error, _} = Exec.exec([1])
    assert {:error, _} = Exec.exec(["foo", 1])
    assert {:error, _} = Exec.exec(["foo"])
  end
end
