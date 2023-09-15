require_relative 'board'
require_relative 'cell'
require_relative 'move'
require 'colorize'


class Game
  attr_accessor :board
  
  def initialize
    @board = Board.new
  end

  def play
    # user_move will be received via some player_input method
    user_move = 'D7D5'
    @board.print_board
    move = Move.new(@board.cells, user_move)
    move.move_piece
    @board.print_board
    move.undo_move
    @board.print_board
    nil
  end
end
