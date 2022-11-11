require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = []
    10.times { @grid << ('A'..'Z').to_a.sample }
    @grid
  end

  def score
    @word = params[:word]
    @grid = params[:grid]
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    open_url = URI.open(url).read
    result = JSON.parse(open_url)
    # check if found is true for valid english word
    @found = result['found']
    @score = result['length']
    @valid = valid_word(@grid, @word)
    if @found && @valid
      @message = "Congratulations! #{@word.capitalize} is a valid word. Your score is #{@score}."
    else
      @message = "Sorry, #{@word} is an invalid word. Your score is 0."
    end
  end

  private

  def valid_word(grid, word)
    # check if all letters are in the grid
    grid = grid.split(' ')
    in_grid = true
    word.upcase.chars.each do |letter|
      if grid.none?(letter)
        in_grid = false
      elsif grid.include?(letter)
        grid[grid.index(letter)] = 0
      end
    end
    return in_grid
  end
end
