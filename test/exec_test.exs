defmodule ExecvTest do
  use ExUnit.Case

  test "exec" do
    assert {:error, _} = Execv.exec([])
    assert {:error, _} = Execv.exec([1])
    assert {:error, _} = Execv.exec(["foo", 1])
    assert {:error, _} = Execv.exec(["foo"])
  end
end
