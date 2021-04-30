dictionary = File.open('5desk.txt','r')
words = []

def clean_dictionary(target_array, source_file)
  while !source_file.eof?
    word = source_file.readline
    word.downcase!
    word.gsub!("\n",'')
    word.gsub!("\r",'')
    target_array.push(word) if word.length >= 5 && word.length <= 12
  end
end

class HangmanGame
  def initialize(word)
    @word = word
  end
end

clean_dictionary(words, dictionary)
