module PieceMovement
  # pawn specific methods

  def pawn_legal_move?
    return false unless right_color? && @move.origin_piece.type == 'P'

    one_space = pawn_one_space?

    two_spaces = pawn_two_space?

    capture = pawn_capture?

    en_passant = en_passant?

    return one_space || two_spaces || capture || en_passant
  end

  def pawn_one_space?
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
    return false unless legal_capture?

    diagonal = diagonal_pawn?

    has_piece = !@move.destination_cell.empty?

    diagonal && has_piece
  end



  def en_passant?
    return false unless @previous_move_obj

    diagonal = diagonal_pawn?

    # The capturing pawn must have advanced exactly three ranks to perform this move.
    legal_rank = en_passant_rank?

    # The captured pawn must have moved two squares in one move, landing right next to the capturing pawn.
    legal_captured_piece_type = @previous_move_obj.destination_piece.type == 'P'

    neighboring_file = difference(@previous_move_obj.destination_coordinates[1], @move.origin_coordinates[1]) == 1

    capture_direction = @previous_move_obj.destination_coordinates[1] == @move.destination_coordinates[1]

    diagonal && legal_rank && legal_captured_piece_type && neighboring_file && capture_direction
  end

  def en_passant_rank?
    if @current_player.color == 'black'
      return true if @move.origin_coordinates[0] == 3 && @previous_move_obj.destination_coordinates[0] == 3
    else
      return true if @move.origin_coordinates[0] == 4 && @previous_move_obj.destination_coordinates[0] == 4
    end
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
    return false unless right_color? && legal_capture? && @move.origin_piece.type == 'N'

    knight_one_two = true if difference(@move.origin_coordinates[0], @move.destination_coordinates[0]) == 1 && difference(@move.origin_coordinates[1], @move.destination_coordinates[1]) == 2

    knight_two_one = true if difference(@move.origin_coordinates[0], @move.destination_coordinates[0]) == 2 && difference(@move.origin_coordinates[1], @move.destination_coordinates[1]) == 1

    return knight_one_two || knight_two_one
  end

  # rook specific methods

  def rook_legal_move?
    return false unless right_color? && legal_capture? && @move.origin_piece.type == 'R'

    vertical_movement = vertical? && vertical_path_clear?

    horizontal_movement = horizontal? && horizontal_path_clear?

    return vertical_movement || horizontal_movement
  end

  # bishop specific methods

  def bishop_legal_move?
    return false unless right_color? && legal_capture? && @move.origin_piece.type == 'B'

    movement = diagonal?

    path_clear = diagonal_path_clear?

    return movement && path_clear
  end

  # queen specific methods

  def queen_legal_move?
    return false unless right_color? && legal_capture? && @move.origin_piece.type == 'Q'

    vertical_movement = vertical? && vertical_path_clear?

    horizontal_movement = horizontal? && horizontal_path_clear?

    diagonal_movement = diagonal? && diagonal_path_clear?

    return vertical_movement || horizontal_movement || diagonal_movement
  end

  # king specific methods

  def king_legal_move?
    return false unless right_color? && legal_capture? && @move.origin_piece.type == 'K'

    one_space = king_one_space?

    castle = castle?

    return one_space || castle
  end

  def king_one_space?
    file_one_space = difference(@move.origin_coordinates[0], @move.destination_coordinates[0]) < 2

    rank_one_space = difference(@move.origin_coordinates[1], @move.destination_coordinates[1]) < 2

    return file_one_space && rank_one_space
  end

  def castle?
    return false unless right_color? && @move.origin_piece.type == 'K'

    # horizontal movement == positive two spaces && no vertical movement
    kingside = @move.destination_coordinates[1] == (@move.origin_coordinates[1] + 2)

    # horizontal movement == negative 3 spaces && no vertical movement
    queenside = @move.destination_coordinates[1] == (@move.origin_coordinates[1] - 2)

    return queenside || kingside
  end
end
