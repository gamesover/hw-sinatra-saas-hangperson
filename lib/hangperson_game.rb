class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  attr_reader :word, :guesses, :wrong_guesses, :word_with_guesses

  def initialize(word)
    @word = word
    @left_word = word
    @guesses = ''
    @wrong_guesses = ''
    @word_with_guesses = '-' * word.size
  end

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri, {}).body
  end

  def guess ch
    if ch.nil? || ch.empty? || !ch.match(/^[[:alpha:]]$/)
      raise ArgumentError
    end

    return false if /[[:lower:]]/ !~ ch || repeat_guess?(ch)

    locations = get_occurrence_index @word, @word_with_guesses, ch

    if locations.size > 0
      @guesses << ch

      locations.each do |pos|
        @word_with_guesses[pos] = ch
      end
    else
      @wrong_guesses << ch unless @wrong_guesses.include? ch
    end

    true
  end

  def repeat_guess?(ch)
    @word_with_guesses.include?(ch) || @wrong_guesses.include?(ch)
  end

  def check_win_or_lose
    if @word_with_guesses == @word
      :win
    elsif @wrong_guesses.size > 6
      :lose
    else
      :play
    end
  end

  private

  def get_occurrence_index word, word_with_guesses, ch
    (0 ... word.length).find_all do |i|
      word[i] == ch && word_with_guesses[i] == '-'
    end
  end
end
