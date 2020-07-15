# Let computer make a list of four randomized colors
#   -create array of six possible colors
#   -shuffle the array and select first one
#   -push into new CONSTANT called mastermind_key
#   -repeat 4 times
# Ask player to guess four colors
#   -store in array called player_guess
# create a copy of the the mastermind_key and the player_guess 
# loop through each index of player_guess_copy to see if it's a match to the same index of the mastermind_key_copy 
#   -if there is an exact match, push the index of the match into a new array called direct_matches
#   -then delete the matches from both the player_guess_copy and teh mastermind_key_copy
# loop through the remaining colors in the player_guess_copy to see if they're included in the mastermind_key_copy
#   -if a color is included, store its index from the mastermind_key_copy in a new array called color_matches
#   -then delete that color from the mastermind_key_copy
#   -continue the loop
# Reset the mastermind_key_copy to the mastermind_key
# Create a new hash called turn_history that stores the player_guess as a key and the direct_matches and color_matches as a value
# play game up to 12 times
#   -if a player turn results in 4 direct matches, end game and declare player the winner
#   -if 4 direct matches are found before 12 turns are up, declare the computer the winner
require "pry"

module Playable
  @@direct_matches = []
  @@color_matches = []

  def check_for_direct_matches(guess, key)
    i = 0
    while i < 4
      if guess[i] == key[i]
        @@direct_matches.push(i)
      end
      i += 1
    end
  end

  def delete_matches(to_delete, array) #delete the matches from the guesses array, then key array
    (0..3).each do |i|
      if to_delete.include?(i)
        array.delete_at(i)
      end
    end
    array
  end

  def check_for_color_matches(guess, key)
    i = 0
    while i < guess.length
      if key.include?(guess[i])
        @@color_matches.push(i)
      end
      i += 1
    end
  end

  def check_for_winner
    @@direct_matches == 4 
  end

  def give_feedback
    puts "Direct matches: #{@@direct_matches.length}"
    puts "Color matches: #{@@color_matches.length}"
    puts "Guess again."
  end

  def reset_for_new_round(guess, d_matches, c_matches)
    d_matches = []
    c_matches = []
    guess = []
  end


end

class PlayMastermind
  include Playable

  attr_accessor :name

  def initialize
    @name = gets.chomp
    @player_guess = []
    @colors = %w(white black blue red green yellow)
    secret_key_creator
  end
  
  def get_player_guess
    puts "Try to guess the Mastermind's code. (Enter four colors.)"
    4.times do
      color = gets.chomp.downcase.strip
      until @colors.include?(color)
        puts "Choose from white, black, blue, red, green, or yellow."
        color = gets.chomp.downcase.strip
      end
      @player_guess.push(color)
    end
  end

  def check_for_matches(guess, key)
    guess_copy = guess; key_copy = key
    check_for_direct_matches(guess_copy, key_copy)
    delete_matches(@@direct_matches, guess_copy)
    delete_matches(@@direct_matches, key_copy)
    check_for_color_matches(guess_copy, key_copy)
  end

  def play_game
    12.times do
      get_player_guess
      puts "You guessed: #{@player_guess}"
      check_for_matches(@player_guess, mastermind_key)
      give_feedback
      reset_for_new_round(@player_guess, @direct_matches, @color_matches)
    end
  end

  private
  
  def secret_key_creator
    @mastermind_key = []
    4.times do
      @colors = @colors.shuffle
      @mastermind_key.push(@colors.first)
    end

    def mastermind_key
      @mastermind_key
    end
  end
end

puts "Wbat's your name?"
game = PlayMastermind.new
puts
puts "Welcome, #{game.name}."
game.play_game



