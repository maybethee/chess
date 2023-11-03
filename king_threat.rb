module KingThreat
  # methods regarding being in check

  def coordinates_to_move_string(origin_coordinates, destination_coordinates)
    char_conversion = { 'a': 0, 'b': 1, 'c': 2, 'd': 3, 'e': 4, 'f': 5, 'g': 6, 'h': 7 }

    origin_file = char_conversion.key(origin_coordinates[1])
    origin_rank = origin_coordinates[0] + 1

    destination_file = char_conversion.key(destination_coordinates[1])
    destination_rank = destination_coordinates[0] + 1

    "#{origin_file}#{origin_rank}#{destination_file}#{destination_rank}"
  end

  def find_king(chosen_player)
    return @move.destination_coordinates if @move.origin_piece.type == 'K'

    @move.current_game_board.each_with_index do |row, r_id|
      c_id = row.find_index do |cell|
        next if cell.empty?

        cell.square.type == 'K' && cell.square.color == chosen_player.color
      end
      return [r_id, c_id] if c_id
    end
    nil
  end

  def gather_piece_locations(chosen_player)
    player_pieces = []
    @move.current_game_board.each_with_index do |row, r_id|
      row.each_with_index do |cell, c_id|
        # ignore empty squares
        next if cell.empty?

        player_pieces << [r_id, c_id] unless cell.square.color != chosen_player.color
      end
    end
    player_pieces
  end

  def safe_from_check?(chosen_player)
    opposite_player = chosen_player.color == @current_player.color ? @opponent_player : @current_player

    chosen_player_king = find_king(chosen_player)
    opposite_player_pieces = gather_piece_locations(opposite_player)

    opposite_player_pieces.each do |coordinate_pair|
      new_move_string = coordinates_to_move_string(coordinate_pair, chosen_player_king)

      new_move = Move.new(@move.current_game_board, chosen_player, new_move_string)

      # false means an opposing player's piece can capture the king being checked
      return false if LegalityChecker.new(new_move, opposite_player).legal_move?
    end
    return true
  end

  def checkmate?
    opponent_player_pieces = gather_piece_locations(@opponent_player)

    all_coordinates.each do |destination_coordinate|

      opponent_player_pieces.each do |piece_coordinate|

        simulated_move_string = coordinates_to_move_string(piece_coordinate, destination_coordinate)
        simulated_move = Move.new(@move.current_game_board, @opponent_player, simulated_move_string)

        next unless LegalityChecker.new(simulated_move, @opponent_player).legal_move?
        simulated_move.move_piece

        if LegalityChecker.new(simulated_move, @opponent_player).safe_from_check?(@opponent_player)
          puts "not checkmated"
          simulated_move.undo_move
          return false
        else
          simulated_move.undo_move
        end
      end
    end
    puts 'CHECKMATE!'
    return true
  end

  def all_coordinates
    (0...8).flat_map { |row| (0...8).map { |col| [row, col] } }
  end
end
