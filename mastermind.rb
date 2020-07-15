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
    to_delete = to_delete.reverse
    to_delete.each do |num|
      array.delete_at(num)
    end
    array
  end

  def check_for_color_matches(guess, key)
    i = 0
    while i < guess.length
      match = key.index(guess[i])
      if match != nil
        @@color_matches.push(i)
        key.delete_at(match)
      end
      i += 1
    end
  end

  def check_for_winner
    if @@direct_matches.length == 4 
      puts "You cracked the Mastermind's code in #{@turn_counter} turns"
      exit
    end
  end

  def give_feedback
    puts "Direct matches: #{@@direct_matches.length}"
    puts "Color matches: #{@@color_matches.length}"
    puts; puts
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
    @turn_counter = 0
  end
  
  def get_player_guess
    puts "Try to guess the Mastermind's four-color code. (Color choices: white, black, blue, red, green, or yellow.)"
    colors = gets.chomp.downcase.strip.gsub(/,/, "").split
    colors.each do |color|
      until @colors.include?(color)
        puts "#{color} is not a valid color. Choose from white, black, blue, red, green, or yellow."
        color = gets.chomp.downcase.strip
      end
      @player_guess.push(color)
    end
  end

  def check_for_matches(guess, key)
    check_for_direct_matches(guess, key)
    delete_matches(@@direct_matches, guess)
    delete_matches(@@direct_matches, key)
    check_for_color_matches(guess, key)
  end

  def reset_for_new_round
    @player_guess = []
    @@direct_matches = []
    @@color_matches = []
    puts "You have #{12 - @turn_counter} turns left. Guess again."
  end

  def play_game
    12.times do
      @turn_counter += 1
      get_player_guess
      puts
      puts "You guessed: #{@player_guess.join(" ")}"
      guess_copy = @player_guess.dup; key_copy = mastermind_key.dup
      check_for_matches(guess_copy, key_copy)
      check_for_winner
      give_feedback
      reset_for_new_round
    end
    puts "You failed to crack the Mastermind's code. You are a loser."
    puts "The code was #{mastermind_key.join(" | ")}"
  end

  private
  
  def secret_key_creator
    @mastermind_key = []
    4.times do
      @colors = @colors.shuffle
      @mastermind_key.push(@colors.first)
    end
  end

  def mastermind_key
    @mastermind_key
  end
end

puts "What's your name?"
game = PlayMastermind.new
puts
puts "Welcome, #{game.name}."
game.play_game



