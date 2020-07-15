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

  def delete_matches(to_delete, array)
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
      if key.includes?(guess[i])
        @@color_matches.push(i)
      end
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

  def direct_matches
    @@direct_matches
  end

end

class Computer

  attr_reader :mastermind_key

  def initialize
    @colors = %w(white black blue red green yellow)
    @mastermind_key = []
    key_creator
  end

  def key_creator
    4.times do
      @colors = @colors.shuffle
      @mastermind_key.push(@colors.first)
    end
  end
end

class PlayMastermind
  include Playable

  attr_accessor :name

  def initialize
    @name = gets.chomp
    @player_guess = []
  end
  
  def get_player_guess
    puts "Try to guess the Mastermind's code. (Enter four colors.)"
    4.times do
      @player_guess.push(gets.chomp)
    end
  end

  def play_game

end

puts "Wbat's your name?"
game = PlayMastermind.new
puts
puts "Welcome, #{game.name}."
game.play_game



