class Game
  attr_reader :dict
  def initialize(file)
    @dict = load_dictionary(file)
  end

  def load_dictionary(file)
    dict = File.open(file, 'r')
    list_of_words = []
    dict.each {|line| list_of_words << line.upcase.chomp if line.chomp.length.between?(5,12) }
    list_of_words
  end

  def new_round
    @word_to_guess = dict.sample.split('')
    @guesses_left = 10
    @right_guesses = []
    @wrong_guesses = []
    new_turn
  end

  def new_turn
    display_state_of_the_game
    guess = correct_input
    if @word_to_guess.include?(guess) 
      @right_guesses << guess 
    else 
      @wrong_guesses << guess
      @guesses_left -= 1
    end
    check_end_of_game
  end

  def display_state_of_the_game
    puts "You have #{@guesses_left} guesses left \n"
    @guesses_left == 10 || puts("Wrong guesses : #{@wrong_guesses.join(', ')}")
    puts "Find the word : #{display_word(@word_to_guess)}"
  end

  def correct_input
    char = ''
    until (char.length == 1 && char.match(/[a-zA-Z]/)) do 
      puts "Enter your guess: "
      char = gets.chomp
    end
    char.upcase
  end

  def display_word(original)
    original.map {|letter| @right_guesses.include?(letter) ? letter : "_"}
                 . join(" ")
  end

  def check_end_of_game
    if @guesses_left == 0
      puts "No guesses left... You lost"
      puts "The word to guess was #{@word_to_guess.join('')}"
      ask_for_a_new_game
    elsif display_word(@word_to_guess).include?("_")
      new_turn
    else
      puts "Victory ! Congratulations!"
      puts "The word to find was indeed #{@word_to_guess.join('')}"
      ask_for_a_new_game
    end
  end

  def ask_for_a_new_game
    puts "Do you want to play again ? (Y/n)"
    answer = gets.chomp
    if answer.match(/^[Nn]/)
      exit
    else
      new_round
    end
  end

end



Game.new("5desk.txt").new_round