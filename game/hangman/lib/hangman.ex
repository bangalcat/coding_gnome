defmodule Hangman do
  alias Hangman.Server, as: HangmanServer

  def new_game() do
    {:ok, pid} = DynamicSupervisor.start_child(Hangman.Supervisor, HangmanServer)
    pid
  end

  def tally(game_pid) do
    HangmanServer.tally(game_pid)
  end

  def make_move(game_pid, guess) do
    # GenServer.call(game_pid, {:make_move, guess})
    HangmanServer.make_move(game_pid, guess)
  end
end
