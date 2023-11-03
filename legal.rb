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

  attr_accessor :move, :current_player, :opponent_color

  def initialize(move, current_player)
    @move = move
    @current_player = current_player
    @opponent_color = @current_player.color == 'black' ? 'white' : 'black'
    @opponent_player = Player.new('opponent', @opponent_color.to_s)
  end

  def legal_move?
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
end
