defmodule Hangman.Server do
  use GenServer

  alias Hangman.Game

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    {:ok, Game.new_game()}
  end

  def make_move(pid, guess) do
    GenServer.call(pid, {:make_move, guess})
  end


  #########
  
  def handle_call({:make_move, guess}, _from, game) do
    Game.make_move(game, guess)
    |> reply_call()
  end

  def handle_call({:tally}, _from, game) do
    {game, Game.tally(game)}
    |> reply_call()
  end


  defp reply_call({game, tally}) do
    {:reply, tally, game}
  end
end
