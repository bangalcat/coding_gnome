defmodule Hangman.GameTest do
  use ExUnit.Case

  alias Hangman.Game

  test "new_game returns structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "state isn't changed for :won or :lost game" do
    for state <- [:won, :lost] do
      game = Game.new_game() |> Map.put(:game_state, state)
      assert ^game = Game.make_move(game, "x")
    end
  end

  test "first occurrence of letter is not already used" do
    game = Game.new_game()
    game = Game.make_move(game, "x")
    assert game.game_state != :already_used
  end

  test "second occurrence of letter is not already used" do
    game = Game.new_game()
    game = Game.make_move(game, "x")
    assert game.game_state != :already_used
    game = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Game.new_game("wibble")
    game = Game.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "a guessed word is a won game" do
    assert_move("wibble", [
      {"w", :good_guess, 7, "w_____"},
      {"i", :good_guess, 7, "wi____"},
      {"b", :good_guess, 7, "wibb__"},
      {"l", :good_guess, 7, "wibbl_"},
      {"e", :won, 7, "wibble"},
    ])
  end

  test "bad guess is recognized" do
    assert_move "wibble", [
      {"x", :bad_guess, 6, "______"}
    ]
  end

  test "lost game is recognized" do
    assert_move "w", [
      {"a", :bad_guess, 6, "_"},
      {"b", :bad_guess, 5, "_"},
      {"c", :bad_guess, 4, "_"},
      {"d", :bad_guess, 3, "_"},
      {"e", :bad_guess, 2, "_"},
      {"f", :bad_guess, 1, "_"},
      {"r", :lost, 1, "_"},
    ]
  end

  defp assert_move(word, moves) do
    Enum.reduce(
      moves,
      Game.new_game(word),
      fn {guess, state, turns_left, word}, game -> 
        game = Game.make_move(game, guess)
        tally = Game.tally(game)

        assert game.game_state == state
        assert game.turns_left == turns_left
        assert tally.game_state == state
        assert tally.turns_left == turns_left
        assert tally.letters == String.codepoints(word)

        game
      end
    )
  end
end
