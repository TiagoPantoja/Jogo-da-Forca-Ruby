class Board
    attr_reader :board
    def initialize(word)
      @word = word.gsub!(/\s+/, '').downcase
      @board = Array.new(word.length, '_')
    end
  
    def complete?
      @board.include?('_') == false
    end
  
    def display
      puts board.join(" ")
    end
  
    def update(guess)
      @word.each_char.with_index { |letter, index| board[index] = letter if letter == guess}
    end
  end