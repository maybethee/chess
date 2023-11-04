require_relative 'board'
require_relative 'player'
require_relative 'cell'
require_relative 'move'
require_relative 'piece'
require_relative 'legal'
require 'colorize'

class Game
  attr_reader :players, :current_player
  attr_accessor :board

  def initialize
    @board = Board.new
    @players = [Player.new('Player 1', 'white'), Player.new('Player 2', 'black')]
    @current_player = @players.first
  end

  def play
    @board.print_board
    loop do
      current_move = Move.new(@board.cells, @current_player, player_input)

      switch_players unless current_move.execute_move == false

      @board.print_board

      break if current_move.game_over == true
    end
    puts 'game over, thanks for playing!'
  end

  def player_input
    puts "#{@current_player.color}, enter your move\n\n"
    loop do
      error_message = "invalid input\n\n"
      player_move_string = gets.chomp
      return player_move_string if valid?(player_move_string.downcase)

      puts error_message
    end
  end

  def valid?(string)
    !!string.match?(/\A[a-h][1-8][a-h][1-8]\z/)
  end

  def switch_players
    @current_player = @players.rotate!.first
  end
end
