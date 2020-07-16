# Let computer make a list of four randomized colors
#   -create array of six possible colors
#   -shuffle the array and select first one
#   -push into new CONSTANT called computer_key
#   -repeat 4 times
# Ask player to guess four colors
#   -store in array called player_guess
# create a copy of the the computer_key and the player_guess 
# loop through each index of player_guess_copy to see if it's a match to the same index of the computer_key_copy 
#   -if there is an exact match, push the index of the match into a new array called direct_matches
#   -then delete the matches from both the player_guess_copy and teh computer_key_copy
# loop through the remaining colors in the player_guess_copy to see if they're included in the computer_key_copy
#   -if a color is included, store its index from the computer_key_copy in a new array called color_matches
#   -then delete that color from the computer_key_copy
#   -continue the loop
# Reset the computer_key_copy to the computer_key
# Create a new hash called turn_history that stores the player_guess as a key and the direct_matches and color_matches as a value
# play game up to 12 times
#   -if a player turn results in 4 direct matches, end game and declare player the winner
#   -if 4 direct matches are found before 12 turns are up, declare the computer the winner
require "pry"

module Switchable
  @@play_as_mastermind = false
  
  def pick_side
    answer = gets.chomp.downcase.strip.gsub(/'/, '')
    until answer == 'mastermind' || answer == 'code breaker'
      answer = gets.chomp.downcase.strip
    end
    if answer == 'mastermind'
      @@play_as_mastermind = true
    end
  end

  def play_as_mastermind
    @@play_as_mastermind
  end
end


class GameMethods
  include Switchable
  @@direct_matches = []
  @@color_matches = []

  def check_for_direct_matches(guess, key)
    i = 0
    while i < 4
      if guess[i] == key[i]
        @@direct_matches.push(i) #won't need teh acutal index after this point, just the length @@direct_matches
      end
      i += 1
    end
  end

  def delete_matches(to_delete, array)
    to_delete = to_delete.reverse #so indexes don't shift down as items are being deleted
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
      puts "Well done, #{name}! You cracked the Mastermind's code in #{@turn_counter} turns."
      exit
    end
  end

  def give_feedback
    puts "Direct matches: #{@@direct_matches.length}"
    puts "Color matches: #{@@color_matches.length}"
    puts; puts
  end

  def reset_for_new_round
    @player_guess = []
    @@direct_matches = []
    @@color_matches = []
    if @@play_as_mastermind == true
      computer_key = []
      puts "The computer has #{12 - @turn_counter} turns left."
    else
      puts "You have #{12 - @turn_counter} turns left."
    end
  end
end

class PlayMastermind < GameMethods

  attr_accessor :name, :computer_key

  def initialize
    @name = gets.chomp
    @player_guess = []
    @colors = %w(white black blue red green yellow)
    @turn_counter = 0
  end
  
  def get_player_guess
    if @@play_as_mastermind == false
      if @turn_counter == 1
        puts
        puts "BEGIN"
        puts "Try to guess the Mastermind's four-color code. (Color choices: white, black, blue, red, green, or yellow.)"
      else
        puts "Guess again. (Color choices: white, black, blue, red, green, or yellow.)"
      end
    end
    convert_player_guess
    check_guess_length
  end

  def convert_player_guess
    colors = gets.chomp.downcase.strip.gsub(/,/, "").split
    colors.each do |color|
      until @colors.include?(color)
        puts "#{color} is not a valid color. Choose from white, black, blue, red, green, or yellow."
        color = gets.chomp.downcase.strip
      end
      @player_guess.push(color)
    end
  end

  def check_guess_length
    if @player_guess.length != 4
      @player_guess = []
      puts
      puts "Error: Code should be four colors."
      puts
      get_player_guess
    end
  end

  def comp_key_creator
    @computer_key = []
    4.times do
      @colors = @colors.shuffle
      @computer_key.push(@colors.first)
    end
  end

  def check_for_matches(guess, key)
    check_for_direct_matches(guess, key)
    delete_matches(@@direct_matches, guess)
    delete_matches(@@direct_matches, key)
    check_for_color_matches(guess, key)
  end
  
  def play_game
    comp_key_creator
    12.times do
      @turn_counter += 1
      get_player_guess
      puts
      puts "You guessed: #{@player_guess.join(" ")}"
      guess_copy = @player_guess.dup; key_copy = computer_key.dup
      check_for_matches(guess_copy, key_copy)
      check_for_winner
      give_feedback
      reset_for_new_round
    end
  end
  
  def ready
    until gets.chomp.downcase.strip.gsub(/'/, "") == "ready"
      puts "Type 'ready' to begin."
    end
  end

end

class BeMastermind < PlayMastermind #only for playing as Mastermind
  attr_accessor :player_key

  def initialize
    @player_guess = []
    @colors = %w(white black blue red green yellow)
    @turn_counter = 0
    @player_key = get_player_guess
    @@play_as_mastermind == true
  end

  def play_game_as_mastermind
    12.times do 
      @turn_counter += 1
      comp_key_creator
      puts
      puts "The computer guessed: #{computer_key.join(" ")}"
      guess_copy = computer_key.dup; key_copy = player_key.dup
      check_for_matches(guess_copy, key_copy)
      check_for_winner
      give_feedback
      reset_for_new_round
    end
    puts "You failed to crack the Mastermind's code. You are a loser, #{name}."
    puts "The code was #{computer_key.join(" ")}"
  end
end


puts "What's your name?"
game = PlayMastermind.new
puts "Type 'Code Breaker' to break the Mastermind's code (default gameplay)."
puts "Type 'Mastermind' to have the computer try to break your code."
game.pick_side
puts
if game.play_as_mastermind == false
  puts "Welcome, #{game.name}."
  puts
  puts "The Mastermind has created a secret code and it's your job crack it. You have 12 guesses."
  puts
  puts "The code is comprised of four colors. Colors may or may not be repeated."\
  "The color choices are white, black, blue, red, green, or yellow."
  puts
  puts "If you can't guess the four colors in their exact order within 12 attempts, you lose and the Mastermind wins."
  puts
  puts "After each guess, the Mastermind will tell you if you had any direct matches"\
  "(correct color, correct location), or color matches (correct color, wrong location)"
  puts "Type 'ready' to begin."
  game.ready
  game.play_game
else
  othergame = BeMastermind.new
  puts "Type 'ready' to begin."
  othergame.ready
  BeMastermind.play_game_as_mastermind
end



