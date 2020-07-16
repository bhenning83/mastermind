require "pry"

#All methods to be used by both PlayAsMastermind and PlayAsCodeBreaker classes
module GameMethods
  @@direct_matches = []
  @@color_matches = []
  @@player_key = []
  @@colors = %w[white black blue red green yellow]
  @@turn_counter = 0

  def check_for_direct_matches(guess, key)
    i = 0
    while i < 4
      @@direct_matches.push(i) if guess[i] == key[i]
      i += 1
    end
  end

  #deletes matches so they're not also counted as color matches
  def delete_matches(to_delete, array)
    to_delete = to_delete.reverse # so indexes don't shift down as items are being deleted
    to_delete.each do |num|
      array.delete_at(num)
    end
    array
  end

  def check_for_color_matches(guess, key)
    i = 0
    while i < guess.length
      match = key.index(guess[i])
      unless match.nil?
        @@color_matches.push(i) # won't need the acutal index after this point, just the length @@direct_matches
        key.delete_at(match)
      end
      i += 1
    end
  end

  #If 4 direct matches are found, it puts a winning message and exits the program
  def check_for_winner(message)
    return unless @@direct_matches.length == 4
    puts message
    exit
  end

  def give_feedback
    puts "Direct matches: #{@@direct_matches.length}"
    puts "Color matches: #{@@color_matches.length}"
    puts
    puts
  end

  #clears arrays storing direct matches, color matches, and guess information
  def reset_for_new_round(role)
    if role == 'code breaker'
      @@player_key = []
      puts "You have #{12 - @@turn_counter} turns left."
    else
      @computer_key = []
      answer = ''
      puts "The computer has #{12 - @@turn_counter} turns left."
      puts "Type 'go' to play the next round"
      answer = gets.chomp.downcase.strip until answer == 'go'
    end
    @@direct_matches = []
    @@color_matches = []
  end

  #Checks for direct matches, then deletes those matches from the key and guess arrays. Then checks for color matches
  def check_for_matches(guess, key)
    check_for_direct_matches(guess, key)
    delete_matches(@@direct_matches, guess)
    delete_matches(@@direct_matches, key)
    check_for_color_matches(guess, key)
  end

  def get_player_code
    convert_player_code
    check_guess_length
  end

  #Ensures player is entering valid color options. 
  def convert_player_code
    colors = gets.chomp.downcase.strip.gsub(/,/, '').split
    colors.each do |color|
      until @@colors.include?(color)
        puts "#{color} is not a valid color. Choose from white, black, blue, red, green, or yellow."
        color = gets.chomp.downcase.strip
      end
      @@player_key.push(color)
    end
  end

  def check_guess_length
    return unless @@player_key.length != 4
    @@player_key = []
    puts
    puts 'Error: Code should be four colors.'
    puts
    get_player_code
  end

  def ready
    puts "Type 'ready' to begin." until gets.chomp.downcase.strip.gsub(/'/, '') == 'ready'
  end

  #creates a random sequence of four colors from teh @@colors array
  def comp_key_creator(array)
    4.times do
      @@colors = @@colors.shuffle
      array.push(@@colors.first)
    end
    array
  end
end

#Default game mode. Only initiated if player choses to play as Code Breaker
class PlayAsCodeBreaker
  include GameMethods
  attr_accessor :name, :computer_key

  def initialize
    @name = gets.chomp
    @computer_key = []
  end

  def get_player_code_code_breaker
    if @@turn_counter == 1 #if it's the first turn
      puts
      puts 'BEGIN'
      puts "Try to guess the Mastermind's four-color code. (Color choices: white, black, blue, red, green, or yellow.)"
    else
      puts 'Guess again. (Color choices: white, black, blue, red, green, or yellow.)'
    end
    get_player_code
  end

  #generates a random mastermind key. Loops through a maximum of 12 turns
  def play_game
    @computer_key = comp_key_creator(@computer_key)
    12.times do
      @@turn_counter += 1
      get_player_code_code_breaker
      puts
      puts "You guessed: #{@@player_key.join(' ')}"
      guess_copy = @@player_key.dup; key_copy = computer_key.dup #retains @@player_key and computer_key once matches are deleted
      check_for_matches(guess_copy, key_copy)
      check_for_winner("Well done, #{name}! You cracked the Mastermind's code in #{@@turn_counter} tries.")
      give_feedback
      reset_for_new_round('code breaker')
    end
    puts "You failed to crack the Mastermind's code. You are a loser, #{name}."
    puts "The code was #{computer_key.join(' ')}"
  end
end

#only initializes if player choses to play as Mastermind
class PlayAsMastermind
  include GameMethods
  attr_accessor :name, :computer_key, :keep_matches

  def initialize
    @name = gets.chomp
    @computer_key = []
    @keep_matches = {}
  end

  def get_player_code_mastermind
    puts 'Create your secret coce'
    get_player_code
  end

  #saves direct matches from previous round to be used in next round
  def save_direct_matches
    @@direct_matches.each do |i|
      keep_matches[i] = @@player_key[i]
    end
  end

  def artificial_intelligence
    keep_matches.each do |key, value|
      computer_key[key] = value
    end
  end

  def play_game
    get_player_code_mastermind
    12.times do
      @@turn_counter += 1
      comp_key_creator(@computer_key)
      artificial_intelligence
      binding.pry
      puts
      puts "The computer guessed: #{computer_key.join(' ')}"
      guess_copy = computer_key.dup; key_copy = @@player_key.dup
      check_for_matches(guess_copy, key_copy)
      check_for_winner("Oh no! The the computer cracked your code. You are a loser, #{name}.")
      give_feedback
      save_direct_matches
      reset_for_new_round('mastermind')
    end
    puts
    puts "Well done, #{name}! The computer failed to crack your code."
  end
end

#used to let player pick which role to play as
class PickASide
  attr_accessor :be_the_mastermind

  def initialize
    @be_the_mastermind = false
  end

  #@be_the_mastermind will be used to determind which Class above to initialize
  def side_picker
    answer = gets.chomp.downcase.strip.gsub(/'/, '')
    answer = gets.chomp.downcase.strip until answer == 'mastermind' || answer == 'code breaker'
    @be_the_mastermind = true if answer == 'mastermind'
  end
end

puts 'Welcome to Mastermind by bhenning83.'
puts "Type 'Code Breaker' to break the Mastermind's code (default gameplay)."
puts "Type 'Mastermind' to have the computer try to break your code."
side = PickASide.new
side.side_picker
puts 'Whats your name?'
if side.be_the_mastermind == false
  game = PlayAsCodeBreaker.new
  puts
  puts "Welcome, #{game.name}."
  puts
  puts "The Mastermind has created a secret code and it's your job crack it. You have 12 guesses."
  puts
  puts 'The code is comprised of four colors. Colors may or may not be repeated.'\
  'The color choices are white, black, blue, red, green, or yellow.'
  puts
  puts "If you can't guess the four colors in their exact order within 12 attempts, you lose and the Mastermind wins."
  puts
  puts 'After each guess, the Mastermind will tell you if you had any direct matches'\
  '(correct color, correct location), or color matches (correct color, wrong location).'\
  'Direct matches are not also tallied as color matches'
else
  game = PlayAsMastermind.new
  puts
  puts "Welcome, #{game.name}."
  puts
  puts "As the Mastermind, it's your job to create a secret code that the computer can't crack."
  puts
  puts 'The code is comprised of four colors. Colors may or may not be repeated.'\
  'The color choices are white, black, blue, red, green, or yellow.'
  puts
  puts "If the computer can't guess the four colors in their exact order within 12 attempts, you win."
  puts
end
puts
puts "Type 'ready' to begin."
game.ready
game.play_game
