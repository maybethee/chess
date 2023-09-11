require_relative 'board'
require_relative 'cell'

class Game
  attr_accessor :board
  
  def initialize
    @board = Board.new
  end

  def play
    @board.print_board
    nil
  end
end
