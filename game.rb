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
    @board.print_board

    current_move = Move.new(@board.cells, player_input)
    current_move.move_piece
    @board.print_board
    current_move.undo_move
    @board.print_board
    nil
  end

  def player_input
    puts "@current_player, enter your move"
    loop do
      error_message = 'invalid input'
      player_move_string = gets.chomp
      return player_move_string if valid?(player_move_string.downcase)

      puts error_message
    end
  end

  def valid?(string)
    !!string.match?(/\A[a-h][1-8][a-h][1-8]\z/)
  end
end