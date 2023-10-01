module PieceMovement

  # pawn specific methods

  def pawn_legal_move?
    return false unless right_color? && @move.origin_piece.type == 'P'

    one_space = pawn_one_space?

    two_spaces = pawn_two_space?

    capture = pawn_capture?

    one_space || two_spaces || capture
  end

  def pawn_one_space?
    # using forward? in this and the two_space method means i need to figure out how to flip it once i make computer movement or make the colors/movement vary
    # if @current_player.color == 'white'
    one_space = forward?(1)

    path_clear = @move.destination_cell.empty?
    
    one_space && path_clear
  end

  def pawn_two_space?
    first_move = first_move?(@move.origin_piece)

    two_spaces = forward?(2)

    # need to check both because pawns cannot capture on forward movement, and path clear does not check destination square 
    path_clear = vertical_path_clear? && @move.destination_cell.empty?

    first_move && two_spaces && path_clear
  end

  def pawn_capture?
    return false unless self_capture?

    diagonal = diagonal_pawn?

    # this should eventually also specify color, otherwise self-capture will be possible
    has_piece = !@move.destination_cell.empty?

    diagonal && has_piece
  end

  def diagonal_pawn?
    # black vs. white changes whether operator comparing origin and destination[0] is greater or less than determining possible direction "forward"
    if @current_player.color == 'black'
      true if difference(@move.origin_coordinates[0], @move.destination_coordinates[0]) == 1 && @move.origin_coordinates[0] > @move.destination_coordinates[0] && difference(@move.origin_coordinates[1], @move.destination_coordinates[1]) == 1
    else
      true if difference(@move.origin_coordinates[0], @move.destination_coordinates[0]) == 1 && @move.origin_coordinates[0] < @move.destination_coordinates[0] && difference(@move.origin_coordinates[1], @move.destination_coordinates[1]) == 1
    end   
  end

  def forward?(spaces)
    # black vs. white changes whether operator comparing origin and destination[0] is greater or less than determining possible direction "forward"
    if @current_player.color == 'black'
      true if difference(@move.origin_coordinates[0], @move.destination_coordinates[0]) == spaces && @move.origin_coordinates[0] > @move.destination_coordinates[0] && difference(@move.origin_coordinates[1], @move.destination_coordinates[1]).zero?
    else
      true if difference(@move.origin_coordinates[0], @move.destination_coordinates[0]) == spaces && @move.origin_coordinates[0] < @move.destination_coordinates[0] && difference(@move.origin_coordinates[1], @move.destination_coordinates[1]).zero?
    end
  end

  # knight specific methods

  def knight_legal_move?
    return false unless right_color? && self_capture? && @move.origin_piece.type == 'N'

    knight_one_two = true if difference(@move.origin_coordinates[0], @move.destination_coordinates[0]) == 1 && difference(@move.origin_coordinates[1], @move.destination_coordinates[1]) == 2

    knight_two_one = true if difference(@move.origin_coordinates[0], @move.destination_coordinates[0]) == 2 && difference(@move.origin_coordinates[1], @move.destination_coordinates[1]) == 1

    knight_one_two || knight_two_one
  end

  # check the rest of these like the Knight method (but replace the method in #execute_move)
  # rook specific methods

  def rook_legal_move?
    return false unless right_color? && self_capture? && @move.origin_piece.type == 'R'

    vertical_movement = vertical? && vertical_path_clear?

    horizontal_movement = horizontal? && horizontal_path_clear?

    vertical_movement || horizontal_movement
  end

  # bishop specific methods

  def bishop_legal_move?
    # puts "destination piece color is #{@destination_piece.color}"
    # puts "current player color is #{@current_player.color}"
    return false unless right_color? && self_capture? && @move.origin_piece.type == 'B'

    movement = diagonal?

    path_clear = diagonal_path_clear?

    movement && path_clear
  end

  # queen specific methods

  def queen_legal_move?
    return false unless right_color? && self_capture? && @move.origin_piece.type == 'Q'

    vertical_movement = vertical? && vertical_path_clear?

    horizontal_movement = horizontal? && horizontal_path_clear?

    diagonal_movement = diagonal? && diagonal_path_clear?

    vertical_movement || horizontal_movement || diagonal_movement
  end

  # king specific methods

  def king_legal_move?
    return false unless right_color? && self_capture? && @move.origin_piece.type == 'K'

    one_space = true if difference(@move.origin_coordinates[0], @move.destination_coordinates[0]) < 2 && difference(@move.origin_coordinates[1], @move.destination_coordinates[1]) < 2
    # should specific check restrictions happen here or in another method? same with castling

    one_space
  end
end