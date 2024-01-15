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

  def help_statement
    statement = <<~HELP_STATEMENT

      Play your moves by typing the coordinates of the starting square followed by the destination square.

      For example: to move the white pawn to the E4 square, type 'e2e4' and press ENTER.

      This program will not accept any supplementary or alternative form of notation.

      Other options:
        --'save' to save and quit the game anytime.
        --'help' to print this message again.
    HELP_STATEMENT

    puts statement
  end

  def play
    help_statement
    @board.print_board

    loop do
      player_move_string = player_input

      # move string will not reach return when player inputs 'save', making it nil
      break if player_move_string.nil?

      current_move = Move.new(@board.cells, @current_player, player_move_string, @previous_moves.last)

      if current_move.execute_move
        switch_players
        @previous_moves << player_move_string
      end

      @board.print_board

      break if current_move.game_over == true
    end
    
    puts 'Thanks for playing!'
  end

  def player_input
    puts "#{@current_player.color}, enter your move:"
    loop do
      error_message = "Invalid input.\n\n"
      player_move_string = gets.chomp

      case player_move_string.downcase
      when 'save'
        save_game
        break
      when 'help'
        help_statement
        next
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

  # plays each move normally without printing the board prior to calling the play method, allowing the players to begin where they left off in a "saved" game
  def load_game(previous_moves_file)
    # iterate through array of previous moves loaded from the yaml file
    previous_moves_file.each do |previous_move_string|

      current_move = Move.new(@board.cells, @current_player, previous_move_string)

      # re-add moves to new previous moves array in case of writing over save file
      if current_move.execute_move
        switch_players
        @previous_moves << previous_move_string
      end

    end
    # then calls play method to start game for the player
    play
  end
end
