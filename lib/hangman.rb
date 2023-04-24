require_relative 'game_dict.rb'
require_relative 'board.rb'
require 'yaml'

# Hangman CLI Game
class Hangman
  def initialize
    @score = 0
    @guesses = 12
    @guessed_letters = []
    menu
  end

  def load_file(selection)
    saved_game = YAML::load(File.read("saved_games/game_#{selection}.yaml"))
    saved_game.play_game
  end

  def menu
    print_rules
    if check_ready? 
        puts "Aperte 1 para novo jogo"
        selection = gets.chomp
      end
      selection == "0" ? setup_game : load_file(selection)
    end
  end

  def check_ready?
    puts 'Quer jogar? (S/N)'
    user_input = gets.chomp.downcase
    return true if user_input == 'S' || user_input == 'sim'
    return false
  end

  def select_word
    puts 'Escolhendo uma palavra'
    sleep 0.5
    @word = @word_bank.select_random_word
  end

  def prompt_difficulty_selection
    puts %{
      Dificuldades:
      1 - Fácil
      2 - Normal
      3 - Difícil
    }
    @selected_level = Integer(gets.chomp) rescue false
  end

  def level_valid?
    @selected_level.to_i >= 1 || @selected_level.to_i <= 3
  end

  def guess_valid?
    (@guess =~ /^[A-Z0-9]+$/i && @guess.length == 1) 
  end

  def update_guesses_left
    @guesses -= 1
    puts "Chances restantes: #{@guesses}"
  end

  def get_input
    puts 'Digite uma letra de A até Z ou aperte 1 para começar'
    @guess = gets.chomp.downcase
    if @guess == "1"
      save_game
      exit
    end
  end

  def game_over?
    @guesses <= 0 || @game_board.complete?
  end

  def update_score
    @score += 1
  end

  def determine_winner
    if @game_board.complete?
      puts 'Acertou!'
      update_score
      @lose = false
    else
      puts "A palavra tem #{@word}."
      puts ''
      @lose = true
    end
  end

  def update_guessed_letters
    @guessed_letters << @guess
  end

  def setup_board
    @game_board = Board.new(@word)
  end

  def setup_game
    prompt_difficulty_selection
    if level_valid?
      @word_bank = GameDictionary.new(@selected_level)
      select_word
      setup_board
      play_game
    else
      puts 'Números 1 a 3'
    end
  end

  def display_bunny
    steps_left =  "" * @guesses + ""
    if @lose
      bunny =  <<-'EXPECTED'
      puts congrats
    end
  end

  def play_game
    @game_board.display
    until game_over?
      get_input
      if guess_valid?
        update_guessed_letters
        @game_board.update(@guess)
        @game_board.display
        puts "guessed letters: #{@guessed_letters}"
        update_guesses_left
        display_bunny
      else
        puts 'Letras A até Z'
      end
    end
    determine_winner
    display_bunny
  end
end

game = Hangman.new