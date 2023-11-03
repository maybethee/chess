module PathClear
  # path clear methods

  def vertical_path_clear?
    current_origin = @move.origin_coordinates.dup
    current_destination = @move.destination_coordinates.dup

    if @move.destination_coordinates[0] > @move.origin_coordinates[0]
      until current_origin[0] >= current_destination[0] - 1
        current_origin[0] += 1
        return false unless @move.current_game_board[current_origin[0]][current_origin[1]].empty?
      end
    else
      until current_origin[0] <= current_destination[0] + 1
        current_origin[0] -= 1
        return false unless @move.current_game_board[current_origin[0]][current_origin[1]].empty?
      end
    end
    true
  end

  def horizontal_path_clear?
    current_origin = @move.origin_coordinates.dup
    current_destination = @move.destination_coordinates.dup

    if @move.destination_coordinates[1] > @move.origin_coordinates[1]
      until current_origin[1] >= current_destination[1] - 1
        current_origin[1] += 1
        return false unless @move.current_game_board[current_origin[0]][current_origin[1]].empty?
      end
    else
      until current_origin[1] <= current_destination[1] + 1
        current_origin[1] -= 1
        return false unless @move.current_game_board[current_origin[0]][current_origin[1]].empty?
      end
    end
    true
  end

  # need to think of how to make this more concise...
  def diagonal_path_clear?
    current_origin = @move.origin_coordinates.dup
    current_destination = @move.destination_coordinates.dup

    if @move.destination_coordinates[1] > @move.origin_coordinates[1] && @move.destination_coordinates[0] > @move.origin_coordinates[0]
      until current_origin[1] >= current_destination[1] - 1
        current_origin[0] += 1
        current_origin[1] += 1
        return false unless @move.current_game_board[current_origin[0]][current_origin[1]].empty?
      end
    elsif @move.destination_coordinates[1] > @move.origin_coordinates[1] && @move.destination_coordinates[0] < @move.origin_coordinates[0]
      until current_origin[1] >= current_destination[1] - 1
        current_origin[0] -= 1
        current_origin[1] += 1
        return false unless @move.current_game_board[current_origin[0]][current_origin[1]].empty?
      end
    elsif @move.destination_coordinates[1] < @move.origin_coordinates[1] && @move.destination_coordinates[0] < @move.origin_coordinates[0]
      until current_origin[1] <= current_destination[1] + 1
        current_origin[0] -= 1
        current_origin[1] -= 1
        return false unless @move.current_game_board[current_origin[0]][current_origin[1]].empty?
      end
    elsif @move.destination_coordinates[1] < @move.origin_coordinates[1] && @move.destination_coordinates[0] > @move.origin_coordinates[0]
      until current_origin[1] <= current_destination[1] + 1
        current_origin[0] += 1
        current_origin[1] -= 1
        return false unless @move.current_game_board[current_origin[0]][current_origin[1]].empty?
      end
    end
    true
  end
end
