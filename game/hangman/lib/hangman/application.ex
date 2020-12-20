defmodule Hangman.Application do
  use Application

  def start(_type, _args) do
    children = [
      {DynamicSupervisor, name: Hangman.Supervisor, strategy: :one_for_one}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
