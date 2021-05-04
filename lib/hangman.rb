require 'yaml'

Dir.mkdir('saves') unless Dir.exist?('saves')

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

clean_dictionary(words, dictionary)
dictionary.close

# Game Class
class HangmanGame
  attr_reader :game_over

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
    puts "You already used the letters: #{@used_letters.join(' , ')}" unless @used_letters.empty?
    puts @game_array.join('')
    game_input
    if @input == 'save'
      save_menu
    else
      game_choice
    end
  end

  protected

  attr_reader :letter_array, :turns, :game_array, :used_letters

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
    save_name = (0...5).map { (65 + rand(26)).chr }.join.capitalize
    File.open("saves/#{save_name}.yaml", 'w') do |file|
      file.puts YAML.dump(self)
    end
    puts "\n --- Game Saved - #{save_name}.yaml ---"
  end

  def load_game
    save_array = retrieve_saves
    save_array.each_with_index { |filename, index| puts "#{index + 1}. #{filename}" }
    print 'Enter the number of the save that you want to load: '
    save_number = gets.chomp.to_i
    loaded_save = YAML.load(File.read("saves/#{save_array[save_number - 1]}"))
    copy_hangman(loaded_save)
    puts "\n--- Game Loaded - #{save_array[save_number - 1]} ---"
  end

  def copy_hangman(source)
    @game_array = source.game_array
    @game_over = source.game_over
    @letter_array = source.letter_array
    @turns = source.turns
    @used_letters = source.used_letters
  end

  def retrieve_saves
    saves = Dir.entries('saves')
    saves.delete('.')
    saves.delete('..')
    saves
  end

  def game_choice
    @used_letters.push @input
    update_game_array
    end_game
    if @game_over == false
      sleep(1)
    else
      puts @turns.positive? ? '--- You Won! ---' : "--- You Lost ---\nThe word was \"#{game.letter_array.join('')}\""
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

game = HangmanGame.new(words.sample, 6)

until game.game_over
  game.round
  puts ''
end
