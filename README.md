# Execv

Elixir interface to `exec` system call.

## Installation

The package can be installed
by adding `exec` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:execv, "~> 0.1.0"}]
end
```

## Usage

```elixir

Execv.exec(["/usr/bin/ssh", "my@server"])

Execv.exec(["/bin/echo", "foo", "bar"])

{:error, _} = Execv.exec(["/bin/echoWRONG", "foo", "bar"])

{:error, _} = Execv.exec([123])

```



