module Mastermind
  def self.print_instructions
    puts "This is a command line version of Mastermind.
    You guess colors by putting the first letter of the color you want to guess.
    Separate your letters with a single space.
    The colors are: Red, Black, White, Green, Yellow, and Purple\n"
  end

  def self.create_random_code
    code_colors = %w[R B W G Y P]
    code = []
    4.times { code.push(code_colors.sample) }
    code
  end

  def self.win?(answer, guess)
    answer == guess
  end

  def self.lose?
    Guess.total_guesses >= 12
  end

  def self.calc_reds(answer, guess)
    red = 0
    (0...answer.length).each do |i|
      red += 1 if answer[i] == guess[i]
    end
    red
  end

  def self.calc_whites(answer, guess)
    white = 0
    answer_non_matches = []
    guess_non_matches = []
    (0...answer.length).each do |i|
      if answer[i] != guess[i]
        answer_non_matches.push(answer[i])
        guess_non_matches.push(guess[i])
      end
    end
    %w[R B W G Y P].each do |i|
      white += [answer_non_matches.count(i), guess_non_matches.count(i)].min
    end
    white
  end
end

class Guess
  attr_accessor :guess
  @@num_guesses = 0
  def initialize(colors)
    @guess = colors
    @@num_guesses += 1
  end

  def self.total_guesses
    @@num_guesses
  end

  def self.ask_for_guess
    puts "\nRound #{@@num_guesses + 1}. Take a guess"
    user_guess = Guess.new(gets.chomp.split(' '))
    user_guess.guess
  end
end

# Gameplay
Mastermind.print_instructions # Tell the user how to play
secret_code = Mastermind.create_random_code # generate the secret code

until Mastermind.lose?
  current_guess = Guess.ask_for_guess
  if Mastermind.win?(secret_code, current_guess)
    break
  else
    puts "#{Mastermind.calc_reds(secret_code, current_guess)} small red pins"
    puts "#{Mastermind.calc_whites(secret_code, current_guess)} small white pins\n"
  end
end

if Mastermind.lose?
  puts "You lose! The secret code was #{secret_code}"
else puts 'You win!'
end
