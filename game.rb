require_relative 'board'
require_relative 'cell'
require_relative 'move'
require_relative 'piece'
require 'colorize'


class Game
  attr_accessor :board
  
  def initialize
    @board = Board.new
  end

  def play
    # @board.cells[5][3].square = Piece.new('P', 'black')
    # @board.cells[3][3].square = Piece.new('P', 'black')
    # @board.cells[2][4].square = Piece.new('P', 'black')
    
    @board.print_board
    loop do
      current_move = Move.new(@board.cells, player_input)
      current_move.execute_move
      @board.print_board
      # current_move.undo_move
      # @board.print_board
    end
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
