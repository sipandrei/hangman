require 'yaml'

dictionary = File.open('5desk.txt', 'r')
words = []

def clean_dictionary(target_array, source_file)
  until source_file.eof?
    word = source_file.readline
    word.downcase!
    word.gsub!("\n", '')
    word.gsub!("\r", '')
    target_array.push(word) if word.length >= 5 && word.length <= 12
  end
end

# Game Class
class HangmanGame
  attr_reader :game_over, :turns, :letter_array

  def initialize(word, turns)
    @letter_array = word.split('')
    @game_over = false
    @turns = turns
    @game_array = make_game_array
    @used_letters = []
    puts '--- Game Initialized ! ---'
  end

  def round
    puts "#{@turns} turns left"
    puts "You already used the letters: #{@used_letters.join(' , ')}"
    puts @game_array.join('')
    check_input
    @used_letters.push @input
    update_game_array
    end_game
    if @game_over == false
      sleep(1)
    else
      puts @turns.positive? ? '--- You Won! ---' : '--- You Lost ---'
    end
  end

  private

  def update_game_array
    if @letter_array.include?(@input)
      puts 'Letter present in the mysterious word!'
      @letter_array.each_with_index do |letter, index|
        @game_array[index] = letter if letter == @input
      end
    else
      puts 'Letter not present in the mysterious word!'
      @turns -= 1
    end
  end

  def check_input
    @input = ''
    until ('a'..'z').include?(@input) && !@used_letters.include?(@input)
      puts 'Give a letter that you haven`t already used: '
      @input = gets.chomp.downcase[0]
    end
  end

  def end_game
    return false unless @game_array == @letter_array || @turns.zero?

    puts ''
    puts '--- Game Over ---'
    @game_over = true
  end

  def make_game_array
    if @letter_array.is_a? Array
      Array.new(@letter_array.length, '_')
    else
      puts 'Word needed for game!'
    end
  end
end

clean_dictionary(words, dictionary)
dictionary.close

game = HangmanGame.new(words.sample, 6)

until game.game_over
  game.round
  puts ''
end

puts "The word was \"#{game.letter_array.join('')}\""
