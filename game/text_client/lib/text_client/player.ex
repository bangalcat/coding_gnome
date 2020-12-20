defmodule TextClient.Player do
  alias TextClient.{Mover, Prompter, State, Summary}

  # won, lost, good_guess, bad_guess, already_used, initializing
  def play(%State{tally: %{game_state: :won}} = _state) do
    exit_with_message("You WON!")
  end

  def play(%State{tally: %{game_state: :lost}, game_service: game}) do
    exit_with_message("Sorry, you lost. The answer is #{Enum.join(game.letters)}")
  end

  def play(game = %State{tally: %{game_state: :good_guess}}) do
    continue_with_message(game, "good guess!")
  end

  def play(game = %State{tally: %{game_state: :bad_guess}}) do
    continue_with_message(game, "Sorry, that isn't in the word")
  end

  def play(game = %State{tally: %{game_state: :already_used}}) do
    continue_with_message(game, "You've already used that letter")
  end

  def play(game) do
    continue(game)
  end

  defp continue_with_message(game, message) do
    IO.puts(message)
    continue(game)
  end

  defp continue(game) do
    game
    |> Summary.display()
    |> Prompter.accept_move()
    |> Mover.make_move()
    |> play()
  end

  def prompt(game) do
    game
  end

  def make_move(game) do
    game
  end

  defp exit_with_message(msg) do
    IO.puts(msg)
    exit(:normal)
  end
end
