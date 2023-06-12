
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

class Hangman
  def initialize(model, view)
    @model = model
    @view = view
  end

  def play(word)
    @model.initialize_game(word)
    @view.show_instructions(word.length)
    until @model.game_over?
      @model.guesses_remaining -= 1
      #@model.make_guess(@view.get_player_guess)
    end
  end
end

class HangmanModel
  attr_accessor :secret_word, :uncovered_word, :guesses_remaining
  

  def initialize_game(word)
    self.secret_word = word
    self.guesses_remaining = 5
    self.uncovered_word = word.gsub(/[a-z]/, "_")
  end 

  def game_over?
    return self.secret_word == self.uncovered_word || self.guesses_remaining == 0 
  end
end

class HangmanView
  def show_instructions(word_length)
    puts "Welcome to hangman! Enter a letter you think is in the word."
    puts "If you are wrong, the hangman gets closer to death."
    puts "If you are right, the secret word will reveal where the letter belongs."
    puts "The secret word is #{word_length} letters long."
  end
end

#secret_word = WordGenerator.get_random_word(dictionaryFileName, {min: 5, max: 12})

#secret_word.each_char {|char| print "_" }

dictionaryFileName = "google-10000-english-no-swears.txt"
game = Hangman.new(HangmanModel.new, HangmanView.new)
game.play(WordGenerator.get_random_word(dictionaryFileName, {min: 5, max: 12}))

