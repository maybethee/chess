module KingThreat

  # methods regarding being in check

  def coordinates_to_move_string(origin_coordinates, destination_coordinates)
    char_conversion = { "a": 0, 'b': 1, 'c': 2, 'd': 3, 'e': 4, 'f': 5, 'g': 6, 'h': 7 }

    origin_file = char_conversion.key(origin_coordinates[1])
    origin_rank = origin_coordinates[0] + 1

    destination_file = char_conversion.key(destination_coordinates[1])
    destination_rank = destination_coordinates[0] + 1

    "#{origin_file}#{origin_rank}#{destination_file}#{destination_rank}"
  end

  def find_king(player)
    return @move.destination_coordinates if @move.origin_piece.type == 'K'

    @move.current_game_board.each_with_index do |row, r_id|
      c_id = row.find_index do |cell|
        next if cell.empty?

        cell.square.type == 'K' && cell.square.color == player.color
      end
      return [r_id, c_id] if c_id
    end
    nil
  end

  # excludes the king in returned array by default
  def gather_piece_locations(chosen_player)
    player_pieces = []
    @move.current_game_board.each_with_index do |row, r_id|
      row.each_with_index do |cell, c_id|
        # ignore empty squares and King which cannot check
        next if cell.empty? || cell.square.type == 'K'

        player_pieces << [r_id, c_id] unless cell.square.color != chosen_player.color
      end
    end
    player_pieces
  end

  def safe_from_check?
    opponent_player = Player.new('opponent', @opponent_color)
    current_player_king = find_king(@current_player)
    opponent_pieces = gather_piece_locations(opponent_player)

    opponent_pieces.each do |coordinate_pair|
      new_move_string = coordinates_to_move_string(coordinate_pair, current_player_king)

      new_move = Move.new(@move.current_game_board, opponent_player, new_move_string)

      can_capture = LegalityChecker.new(new_move, opponent_player).legal_move?

      return false if can_capture
    end
  end
end
