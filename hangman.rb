dictionaryFileName = "google-10000-english-no-swears.txt"
def read_in_dictionary(dictionary_file_path)
  return File.readlines(dictionary_file_path) if File.exist?(dictionary_file_path)
  nil
end

wordList = read_in_dictionary(dictionaryFileName).select {|word|  word.length.between?(5,12)}
puts wordList.length