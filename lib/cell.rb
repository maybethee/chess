require 'colorize'

class Cell
  attr_accessor :square

  def initialize(square = ' ')
    @square = square
  end

  def empty?
    @square == ' '
  end
end
