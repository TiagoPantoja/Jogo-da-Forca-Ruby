# Dictionary for games
class GameDictionary

    def initialize(num)
      @filename = '/usr/share/dict/words'
      @difficulty_level = num
      set_word_length
      @dict = load_filtered_dictionary(@filename)
    end
  
    def load_filtered_dictionary(filename)
      File.readlines(filename).select { |line| line if line.length <= @max_length and line.length >= @min_length }
    end
  
    def set_word_length
      if @difficulty_level == 3
        @max_length = 15
        @min_length = 11
      elsif @difficulty_level == 2
        @max_length = 10
        @min_length = 6
      elsif @difficulty_level == 1
        @max_length = 5
        @min_length = 3
      end
    end
  
    def select_random_word
      selected_word = nil
      @dict.each_with_index do |word, index|
        selected_word = word if rand < 1.0 / (index + 1)
      end
      selected_word
    end
  end