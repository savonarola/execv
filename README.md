# Exec

Elixir interface to `exec` system call.

## Installation

The package can be installed
by adding `exec` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:exec, "~> 0.1.0"}]
end
```

## Usage

```elixir

Exec.exec(["/usr/bin/ssh", "my@server"])

Exec.exec(["/bin/echo", "foo", "bar"])

{:error, _} = Exec.exec(["/bin/echoWRONG", "foo", "bar"])

{:error, _} = Exec.exec([123])

```



