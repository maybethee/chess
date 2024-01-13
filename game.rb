require_relative 'board'
require_relative 'player'
require_relative 'cell'
require_relative 'move'
require_relative 'piece'
require_relative 'legal'
require 'colorize'
require 'yaml'

class Game
  attr_reader :players, :current_player
  attr_accessor :board, :previous_moves

  def initialize
    @board = Board.new
    @players = [Player.new('Player 1', 'white'), Player.new('Player 2', 'black')]
    @current_player = @players.first
    @previous_moves = []
  end

  def play
    @board.print_board
    loop do
      player_move_string = player_input

      # move string will not reach return when player inputs 'save', making it nil
      break if player_move_string.nil?

      current_move = Move.new(@board.cells, @current_player, player_move_string)

      switch_players unless current_move.execute_move == false

      @board.print_board

      @previous_moves << player_move_string

      break if current_move.game_over == true
    end
    puts 'thanks for playing!'
  end

  def player_input
    puts "(type 'save' anytime to save and quit the game)\n\n#{@current_player.color}, enter your move"
    
    loop do
      error_message = "invalid input\n\n"
      player_move_string = gets.chomp

      if player_move_string.downcase.eql?('save')
        save_game
        break
      end

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

  def save_game
    File.open('game.yml', 'w') do |file|
      file.write(YAML.dump(@previous_moves))
    end
  end

  def continue
    saved_previous_moves = YAML.safe_load(File.read('game.yml')) 
    load_game(saved_previous_moves)
  end

  # load game quietly playing each move normally without printing board state before calling play
  def load_game(previous_moves_file)
    # iterate through array of previous moves loaded from the yaml file
    previous_moves_file.each do |previous_move_string|

      current_move = Move.new(@board.cells, @current_player, previous_move_string)

      @previous_moves << previous_move_string

      switch_players unless current_move.execute_move == false
    end
    play
  end
end
