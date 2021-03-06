require 'yaml'

class Game
    def initialize(file)
    @guesses_left = 10
    @right_guesses = []
    @wrong_guesses = []
    @word_to_guess = []
    @dict = load_dictionary(file)
    start_new_game
  end

  attr_reader :dict
  attr_accessor :guesses_left, :right_guesses, :wrong_guesses, :word_to_guess

 
  def load_dictionary(file)
    dict = File.open(file, 'r')
    list_of_words = []
    dict.each {|line| list_of_words << line.upcase.chomp if line.chomp.length.between?(5,12) }
    list_of_words
  end

  def start_new_game
    puts "Do you want to load a previous game ? (y/N)"
    answer = gets.chomp
    answer.match(/^[YyOo]/) ? load_game : new_round
    new_turn
  end

  def new_round
    self.word_to_guess = dict.sample.split('')
  end

  def new_turn
    display_state_of_the_game
    guess = correct_input
    if guess == 'SAVE'
      save_game
    elsif word_to_guess.include?(guess) 
      self.right_guesses << guess 
    else 
      self.wrong_guesses << guess
      @guesses_left -= 1
    end
    check_end_of_game
  end

  def display_state_of_the_game
    puts "\nYou have #{guesses_left} guesses left \n"
    guesses_left == 10 || puts("Wrong guesses : #{wrong_guesses.join(', ')}")
    puts "Find the word : #{display_word(word_to_guess)}"
  end

  def correct_input
    input = ''
    until input == "SAVE" || (input.length == 1 && input.match(/[a-zA-Z]/)) do 
      puts "Enter your guess, or type SAVE to save the game: "
      input = gets.chomp
    end
    input.upcase
  end

  def display_word(original)
    original.map {|letter| right_guesses.include?(letter) ? letter : "_"}
                 . join(" ")
  end

  def check_end_of_game
    if guesses_left == 0
      puts "No guesses left... You lost"
      puts "The word to guess was #{word_to_guess.join('')}"
      ask_for_a_new_game
    elsif display_word(word_to_guess).include?("_")
      new_turn
    else
      puts "Victory ! Congratulations!"
      puts "The word to find was indeed #{word_to_guess.join('')}"
      ask_for_a_new_game
    end
  end

  def ask_for_a_new_game
    puts "Do you want to play again ? (Y/n)"
    answer = gets.chomp
    if answer.match(/^[Nn]/)
      exit
    else
      Game.new("5desk.txt")
    end
  end

  def state_of_the_game
    {
    left: @guesses_left,
    wrong: @wrong_guesses,
    right: @right_guesses,
    word: @word_to_guess,
    }
  end

  def save_game
    
    yaml = YAML::dump(self.state_of_the_game)
    File.write("save.yaml", yaml)
    exit
  end

  def load_game
    file = File.open('save.yaml', 'r')
    data = YAML.load file.read
    self.guesses_left = data[:left]
    self.wrong_guesses = data[:wrong]
    self.right_guesses = data[:right]
    self.word_to_guess = data[:word]
  end

end



Game.new("5desk.txt")