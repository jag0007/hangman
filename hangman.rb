require 'yaml'

class WordGenerator 
  def self.get_random_word(dictionary, word_length)
    wordList = read_in_dictionary(dictionary).select { |word| word.length.between?(word_length[:min], word_length[:max]) }
    wordList[rand(wordList.length)]
  end

  def self.read_in_dictionary(dictionary_file_path)
    return File.readlines(dictionary_file_path) if File.exist?(dictionary_file_path)
    nil
  end
end

class HangmanGame
  def initialize(model, view)
    @model = model
    @view = view
  end

  def play
    @view.show_instructions(@model.secret_word.length)
    until @model.game_over?
      @view.show_game_state(@model)
      guess = @view.get_player_guess
      p guess
      puts guess.length
      if guess.eql?("save")
        File.write('tester.yml', @model.to_yaml)
        @model.game_over = true
      elsif !@model.valid_input?(guess)
        @view.invalid_input
      elsif @model.already_guessed?(guess) 
        @view.already_guessed
      else
        @model.make_guess(guess)
      end
    end
    @view.show_result(@model.get_game_result, @model.secret_word)
  end

  def play_new_game(word)
    @model.initialize_game(word)
    self.play
  end

  def play_saved_game(game)
    @model.from_yaml(game)
    self.play
  end
end

class HangmanModel
  attr_accessor :secret_word, :uncovered_word, :guesses_remaining, :guessed_letters, :game_over
  
  def initialize_game(word)
    self.secret_word = word
    self.guesses_remaining = 5
    self.uncovered_word = word.gsub(/[a-z]/, "_")
    self.guessed_letters = []
    self.game_over = false
  end 

  def game_over?
    return self.secret_word == self.uncovered_word || self.guesses_remaining == 0 || @game_over
  end

  def make_guess(letter)
    self.guessed_letters.push(letter)
    self.guesses_remaining -= 1 unless secret_word.include?(letter)
    self.secret_word.each_char.with_index do |char, index|
      if char == letter
        uncovered_word[index] = letter
      end
    end
  end

  def get_game_result
    return "Win" if self.secret_word == self.uncovered_word
    return "Lose" if self.guesses_remaining == 0
  end

  def already_guessed?(guess)
    self.guessed_letters.include?(guess)
  end

  def valid_input?(guess)
    guess.match?("[a-z]") && guess.length == 1
  end

  def from_yaml(data)
    self.secret_word = data[:secret_word]
    self.guesses_remaining = data[:guesses_remaining]
    self.uncovered_word = data[:uncovered_word]
    self.guessed_letters = data[:guessed_letters]
    self.game_over = false
  end

  def to_yaml
    YAML.dump ({
      :secret_word => self.secret_word,
      :guesses_remaining => self.guesses_remaining,
      :uncovered_word => self.uncovered_word,
      :guessed_letters => self.guessed_letters
    })
  end

end

class HangmanView
  def show_instructions(word_length)
    puts "Welcome to hangman! Enter a letter you think is in the word."
    puts "If you are wrong, the hangman gets closer to death."
    puts "If you are right, the secret word will reveal where the letter belongs."
    puts "The secret word is #{word_length} letters long."
  end

  def get_player_guess
    print "What's your guess? "
    guess = gets.chomp.downcase
  end

  def invalid_input
    puts "Input invalid. Try again."
  end

  def already_guessed
    puts "You've already guess that letter. Try again."
  end

  def show_game_state(game_model)
    puts "\nSecret Word: #{game_model.uncovered_word}"
    print "Letters Guessed: "
    game_model.guessed_letters.each { |letter| print " #{letter}" }
    puts "\nBad Guesses Remaining: #{game_model.guesses_remaining}"
  end

  def show_result(result, word)
    puts "You #{result}"
    puts "The Secret Word is #{word}"
  end
end

#secret_word = WordGenerator.get_random_word(dictionaryFileName, {min: 5, max: 12})

#secret_word.each_char {|char| print "_" }

dictionaryFileName = "google-10000-english-no-swears.txt"
#game = HangmanGame.new(HangmanModel.new, HangmanView.new, word = WordGenerator.get_random_word(dictionaryFileName, {min: 5, max: 12}))
game = HangmanGame.new(HangmanModel.new, HangmanView.new)
game.play_saved_game(YAML.load File.read('test.yaml'))

