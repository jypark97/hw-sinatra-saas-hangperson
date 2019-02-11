class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end

  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses

  def initialize(word)
    @word = word
    @guesses = ""
    @wrong_guesses = ""
  end

  def guess(letter)
    valid = TRUE
    if letter == '' || letter == nil
      valid = TRUE
      raise ArgumentError.new("Empty Guess not allowed")
    end
    letter.downcase!
    if @wrong_guesses.include?(letter) || @guesses.include?(letter)
      valid = FALSE
    elsif !(letter =~ /[[:lower:]]/)
      raise ArgumentError.new("Special Symbol not allowed")
      valid = FALSE
    elsif @word.include? (letter)
      @guesses = @guesses + letter
    else
      @wrong_guesses = @wrong_guesses + letter
    end
    return valid
  end

  def word_with_guesses
    progress = ""
    @word.each_char.with_index { |c, index|
      if @guesses.include? c
        progress[index] = c
      else
        progress[index] = "-"
      end
    }
    return progress
  end

  def check_win_or_lose
    if @wrong_guesses.length < 7 && word_with_guesses == @word
      return :win
    elsif @wrong_guesses.length >= 7
      return :lose
    else
      return :play
    end
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
