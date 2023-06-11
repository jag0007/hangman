dictionaryFileName = "google-10000-english-no-swears.txt"
def read_in_dictionary(dictionary_file_path)
  return File.readlines(dictionary_file_path) if File.exist?(dictionary_file_path)
  nil
end

puts read_in_dictionary('stuf').length