dictionaryFileName = "google-10000-english-no-swears.txt"

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

class HangmanController
  def initialize(model, view)
    @model = model
    @view = view
  end

  def play(word)
    model.initialize_game(word)
    puts model.secret_word
  end
end

class HangmanModel
  attr_accessor :secret_word

  def initialize_game(word)
    secret_word = word
  end 
end

class HangmanView
end

secret_word = WordGenerator.get_random_word(dictionaryFileName, {min: 5, max: 12})

secret_word.each_char {|char| print "_" }

