require 'yaml'

Dir.mkdir('saves') unless Dir.exist?('saves')
saves = Dir.entries('saves')
saves.delete('.')
saves.delete('..')

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

  def initialize(word, turns, game_over = false, game_array = nil, used_letters = [])
    @letter_array = word.split('')
    @game_over = game_over
    @turns = turns
    @game_array = make_game_array
    @game_array = game_array unless game_array.nil?
    @used_letters = used_letters
    puts '--- Game Initialized ! ---'
  end

  def round
    puts "#{@turns} turns left"
    puts "You already used the letters: #{@used_letters.join(' , ')}"
    puts @game_array.join('')
    game_input
    if @input == 'save'
      save_menu
    else
      game_choice
    end
  end

  private

  def save_menu
    print "1. Save game \n2. Load game \nWhat do you want to do?(1/2 - other choice will leave menu) "
    case gets.chomp.to_i
    when 1
      save_game
    when 2
      load_game
    else
      puts "\nLeft the save menu!"
      round
    end
  end

  def save_game

  end

  def load_game

  end

  def game_choice
    @used_letters.push @input
    update_game_array
    end_game
    if @game_over == false
      sleep(1)
    else
      puts @turns.positive? ? '--- You Won! ---' : '--- You Lost ---'
    end
  end

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

  def game_input
    @input = ''
    until ('a'..'z').include?(@input) && !@used_letters.include?(@input)
      puts 'Give a letter that you haven`t already used (write "save" for save options): '
      @input = gets.chomp.downcase
      break if @input == 'save'

      @input = @input[0]
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
