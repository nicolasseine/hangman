class Game
  attr_reader :dict
  def initialize(file)
    @dict = load_dictionary(file)
  end

  def load_dictionary(file)
    dict = File.open(file, 'r')
    list_of_words = []
    dict.each {|line| list_of_words << line.chomp.downcase if line.chomp.length.between?(5,12) }
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
    puts "Enter your guess: "
    guess = ''
    loop do
      guess = gets.chomp
      break if guess.match(/[a-zA-Z]/)
      
      guess = guess[0].downcase
      puts guess
    end
    
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
    puts "Wrong guesses : #{@wrong_guesses.join(', ')}" unless @guesses_left == 10
    puts "Find the word : #{display_word(@word_to_guess)}"
  end

  def display_word(original)
    original.map {|letter| @right_guesses.include?(letter) ? letter : "_"}
                 . join(" ")
  end

  def check_end_of_game
    if @guesses_left == 0
      puts "No guesses left... You lost"
      puts "The word to guess was #{@word_to_guess.join('')}"
    elsif display_word(@word_to_guess).include?("_")
      new_turn
    else
      puts "Victory ! Congratulations!"
      puts "The word to find was indeed #{@word_to_guess.join('')}"
    end
  end
end



Game.new("5desk.txt").new_round