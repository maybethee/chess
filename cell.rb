require 'colorize'

class Cell
  attr_accessor :square

  def initialize(square = ' ')
    @square = square
    # @color = color
  end

  def empty?
    p "square is empty, right?" if @square == ' '
    true if @square == ' '
  end
end
