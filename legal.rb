require_relative 'path_clear'
require_relative 'piece_movement'
require_relative 'king_threat'

class LegalityChecker
  include PathClear
  include PieceMovement
  include KingThreat

  LEGAL_MOVE_TYPES = {
    pawn_legal_move?: 'P',
    knight_legal_move?: 'N',
    rook_legal_move?: 'R',
    bishop_legal_move?: 'B',
    king_legal_move?: 'K',
    queen_legal_move?: 'Q'
  }.freeze

  attr_accessor :move, :current_player, :opponent_color, :opponent_player, :previous_move_obj

  def initialize(move, current_player, previous_move_obj = nil)
    @move = move
    @current_player = current_player

    # @previous_move_obj is a new Move object storing data for the previous move

    # Note: because it maintains a current board state, some attributes of @previous_move_obj like @origin_coordinates and @origin_piece will point to an empty square, so the @destination counterparts should be used instead
    @previous_move_obj = previous_move_obj
  end

  def legal_move?
    # if move is a castle move (follows basic movement rules)
    if castle?
      # see if it's a legal castle move (follows castle rules)
      return false unless castle_path_clear?

      (@move.origin_coordinates[1]..@move.destination_coordinates[1]).each do |square|

        current_square = LegalityChecker.new(@move, @current_player)

        return false unless current_square.safe_from_check?(@current_player, [@move.origin_coordinates[0], square])

      end
    end

    # remove captured en_passant pawn since normal execute move won't do this
    if pawn_legal_move? && en_passant?
      @previous_move_obj.destination_cell.square = ' '
    end

    LEGAL_MOVE_TYPES.any? do |method, piece_type|
      send(method) if @move.origin_piece.type == piece_type
    end
  end

  def first_move?(piece)
    false if piece == ' '

    true if piece.has_moved == false
  end

  def legal_capture?
    return true if @move.destination_cell.empty?

    return true unless @move.destination_piece.color == @current_player.color
  end

  def right_color?
    return true unless @move.origin_piece.color != @current_player.color
  end

  def vertical?
    file_positive = difference(@move.origin_coordinates[0], @move.destination_coordinates[0]) > 0
    rank_zero = difference(@move.origin_coordinates[1], @move.destination_coordinates[1]).zero?

    file_positive && rank_zero
  end

  def horizontal?
    rank_positive = difference(@move.origin_coordinates[1], @move.destination_coordinates[1]) > 0
    file_zero = difference(@move.origin_coordinates[0], @move.destination_coordinates[0]).zero?

    rank_positive && file_zero
  end

  def diagonal?
    true if difference(@move.origin_coordinates[0], @move.destination_coordinates[0]) == difference(@move.origin_coordinates[1], @move.destination_coordinates[1])
  end

  def difference(a, b)
    (a - b).abs
  end

  # creates new move string based on desired origin and destination coordinates and creates new Move object using said string 
  def new_simulated_move(origin_coordinate, destination_coordinate, player)
    simulated_move_string = coordinates_to_move_string(origin_coordinate, destination_coordinate)
    Move.new(@move.current_game_board, player, simulated_move_string)
  end
end
