require_relative 'path_clear'
require_relative 'piece_movement'

class LegalityChecker
  include PathClear
  include PieceMovement

  LEGAL_MOVESETS = %i[pawn_legal_move? knight_legal_move? rook_legal_move? bishop_legal_move? queen_legal_move? king_legal_move?].freeze

  attr_accessor :move, :current_player

  def initialize(move, current_player)
    @move = move
    @current_player = current_player
  end

  def legal_move?
    puts "origin piece color is #{@move.origin_piece.color}"
    puts "current player color is #{@current_player.color}\n\n"

    LEGAL_MOVESETS.find { |moveset| send(moveset) }
  end

  def first_move?(piece)
    false if piece == ' '

    true if piece.has_moved == false
  end

  def self_capture?
    return true if @move.destination_cell.empty?

    return true unless @move.destination_piece.color == @current_player.color
  end

  def right_color?
    return true unless @move.origin_piece.color != @current_player.color
  end

  def vertical?
    true if difference(@move.origin_coordinates[0], @move.destination_coordinates[0]) > 0 && difference(@move.origin_coordinates[1], @move.destination_coordinates[1]).zero?
  end

  def horizontal?
    true if difference(@move.origin_coordinates[1], @move.destination_coordinates[1]) > 0 && difference(@move.origin_coordinates[0], @move.destination_coordinates[0]).zero?
  end

  def diagonal?
    true if difference(@move.origin_coordinates[0], @move.destination_coordinates[0]) == difference(@move.origin_coordinates[1], @move.destination_coordinates[1])
  end
  
  def difference(a, b)
    (a - b).abs
  end
end
