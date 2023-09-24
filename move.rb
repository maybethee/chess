class Move
  CHAR_CONVERSION = { "a": 0, 'b': 1, 'c': 2, 'd': 3, 'e': 4, 'f': 5, 'g': 6, 'h': 7 }.freeze
  LEGAL_MOVESETS = %i[pawn_legal_move? knight_legal_move? rook_legal_move? bishop_legal_move? queen_legal_move? king_legal_move?].freeze

  attr_accessor :user_move_string, :origin_coordinates, :origin_cell, :origin_piece, :destination_coordinates, :destination_cell, :destination_piece, :current_game_board

  def initialize(current_game_board, user_move_string = nil)
    # @game_board should be the attribute from Game class
    @current_game_board = current_game_board
    
    #move is user inputted coordinate String
    @user_move_string = user_move_string

    @origin_coordinates = translate_origin_coordinates(@user_move_string.downcase, CHAR_CONVERSION)

    # this points to the Cell object at these specific coordinates of the Board object's @cells array
    @origin_cell = current_game_board[@origin_coordinates[0]][@origin_coordinates[1]]

    # this points to the Piece object _within_ the square attribute of the aforementioned Cell object
    @origin_piece = @origin_cell.square
    
    @destination_coordinates = translate_destination_coordinates(@user_move_string.downcase, CHAR_CONVERSION)

    @destination_cell = current_game_board[@destination_coordinates[0]][@destination_coordinates[1]]

    @destination_piece = @destination_cell.square
  end

  def translate_origin_coordinates(coordinate_string, char_int_hash)
    # if string looks like 'e7e5', origin_coordinates array looks like this:
    # [6, 4]
    # 6 being '7' - 1 and 4 being index conversion of 'e'
    [(coordinate_string[1].to_i - 1), char_int_hash.fetch(coordinate_string[0].to_sym)]
  end

  def translate_destination_coordinates(coordinate_string, char_int_hash)
    [(coordinate_string[3].to_i - 1), char_int_hash.fetch(coordinate_string[2].to_sym)]
  end

  def move_piece
    @destination_cell.square = @origin_piece
    @origin_cell.square = ' '  

    @origin_piece.has_moved = true
  end

  def execute_move
    if @origin_cell.empty?
      puts "can't move what's not there!"

      #for whatever big legal_move method that ends up here, it should differentiate evaluations based on origin_piece.type
    elsif legal_move?
      move_piece
    else
      puts 'something else went wrong'
    end
  end    

  def legal_move?
    LEGAL_MOVESETS.find { |moveset| send(moveset) }
  end
  
  def first_move?(piece)
    # figure out why i need this here i forgot
    false if piece == ' '
    
    true if piece.has_moved == false
  end

  def vertical?
    true if difference(@origin_coordinates[0], @destination_coordinates[0]) > 0 && difference(@origin_coordinates[1], @destination_coordinates[1]).zero?
  end

  def horizontal?
    true if difference(@origin_coordinates[1], @destination_coordinates[1]) > 0 && difference(@origin_coordinates[0], @destination_coordinates[0]).zero?
  end

  #make sure this way of checking diagonal movement specifically works with path_clear? check later 
  def diagonal?
    true if difference(@origin_coordinates[0], @destination_coordinates[0]) == difference(@origin_coordinates[1], @destination_coordinates[1])
  end
  
  def difference(a, b)
    (a - b).abs
  end

  # pawn specific methods

  def pawn_legal_move?
    return false unless @origin_piece.type == 'P'
    
    one_space = pawn_one_space?
    
    two_spaces = pawn_two_space?

    capture = pawn_capture?

    one_space || two_spaces || capture
  end

  def pawn_one_space?
    # using forward? in this and the two_space method means i need to figure out how to flip it once i make computer movement or make the colors/movement vary
    one_space = forward?(1)

    path_clear = @destination_cell.empty?
    
    one_space && path_clear
  end

  def pawn_two_space?
    first_move = first_move?(@origin_piece)

    two_spaces = forward?(2)

    # need to check both because pawns cannot capture on forward movement, and path clear does not check destination square 
    path_clear = vertical_path_clear? && @destination_cell.empty?

    first_move && two_spaces && path_clear
  end

  def pawn_capture?
    diagonal = diagonal_pawn?

    # this should eventually also specify color, otherwise self-capture will be possible
    has_piece = !@destination_cell.empty?

    diagonal && has_piece
  end
  
  def diagonal_pawn?
    true if difference(@origin_coordinates[0], @destination_coordinates[0]) == 1 && @origin_coordinates[0] > @destination_coordinates[0] && difference(@origin_coordinates[1], @destination_coordinates[1]) == 1
  end

    # maybe this method could include player.color as a parameter and give it an if else block where they do the opposite "forward"
  def forward?(spaces)
    true if difference(@origin_coordinates[0], @destination_coordinates[0]) == spaces && @origin_coordinates[0] > @destination_coordinates[0] && difference(@origin_coordinates[1], @destination_coordinates[1]).zero?
  end

  # knight specific methods
  def knight_legal_move?
    return false unless @origin_piece.type == 'N'

    knight_one_two = true if difference(@origin_coordinates[0], @destination_coordinates[0]) == 1 && difference(@origin_coordinates[1], @destination_coordinates[1]) == 2

    knight_two_one = true if difference(@origin_coordinates[0], @destination_coordinates[0]) == 2 && difference(@origin_coordinates[1], @destination_coordinates[1]) == 1

    knight_one_two || knight_two_one
  end

  # rook specific methods

  def rook_legal_move?
    return false unless @origin_piece.type == 'R'
    
    vertical_movement = vertical? && vertical_path_clear?

    horizontal_movement = horizontal? && horizontal_path_clear?

    vertical_movement || horizontal_movement
  end

  # bishop specific methods

  def bishop_legal_move?
    return false unless @origin_piece.type == 'B'
    
    movement = diagonal?

    path_clear = diagonal_path_clear?

    movement && path_clear
  end

  # queen specific methods

  def queen_legal_move?
    return false unless @origin_piece.type == 'Q'
    
    vertical_movement = vertical? && vertical_path_clear?

    horizontal_movement = horizontal? && horizontal_path_clear?

    diagonal_movement = diagonal? && diagonal_path_clear?

    vertical_movement || horizontal_movement || diagonal_movement
  end

  # king specific methods

  def king_legal_move?
    return false unless @origin_piece.type == 'K'

    one_space = true if difference(@origin_coordinates[0], @destination_coordinates[0]) < 2 && difference(@origin_coordinates[1], @destination_coordinates[1]) < 2

    # should specific check restrictions happen here or in another method? same with castling

    one_space
  end


  # path clear methods

  def vertical_path_clear?
    current_origin = @origin_coordinates.dup
    current_destination = @destination_coordinates.dup
  
    if @destination_coordinates[0] > @origin_coordinates[0]
      until current_origin[0] >= current_destination[0] - 1
        current_origin[0] += 1
        puts "(adding) current origin after increment: #{current_origin[0]}"
        return false if !current_game_board[current_origin[0]][current_origin[1]].empty?
      end
    else
      until current_origin[0] <= current_destination[0] + 1
        current_origin[0] -= 1
        puts "(subtract) current origin after increment: #{current_origin[0]}"
        return false if !current_game_board[current_origin[0]][current_origin[1]].empty?
      end
    end 
    true
  end

  def horizontal_path_clear?
    puts "doing horizontal\n\n"
    current_origin = @origin_coordinates.dup
    current_destination = @destination_coordinates.dup
  
    if @destination_coordinates[1] > @origin_coordinates[1]
      until current_origin[1] >= current_destination[1] - 1
        current_origin[1] += 1
        puts "(adding) current origin after increment: #{current_origin[0]}"
        return false if !current_game_board[current_origin[0]][current_origin[1]].empty?
      end
    else
      until current_origin[1] <= current_destination[1] + 1
        current_origin[1] -= 1
        puts "(subtract) current origin after increment: #{current_origin[0]}"
        return false if !current_game_board[current_origin[0]][current_origin[1]].empty?
      end
    end 
    true
  end

  # need to think of how to make this more concise...
  def diagonal_path_clear?
    current_origin = @origin_coordinates.dup
    current_destination = @destination_coordinates.dup

    if @destination_coordinates[1] > @origin_coordinates[1] && @destination_coordinates[0] > @origin_coordinates[0]
      until current_origin[1] >= current_destination[1] - 1
        current_origin[0] += 1
        current_origin[1] += 1
        return false if !current_game_board[current_origin[0]][current_origin[1]].empty?
      end
    elsif @destination_coordinates[1] > @origin_coordinates[1] && @destination_coordinates[0] < @origin_coordinates[0]
      until current_origin[1] >= current_destination[1] - 1
        current_origin[0] -= 1
        current_origin[1] += 1
        return false if !current_game_board[current_origin[0]][current_origin[1]].empty?
      end
    elsif @destination_coordinates[1] < @origin_coordinates[1] && @destination_coordinates[0] < @origin_coordinates[0]
      until current_origin[1] <= current_destination[1] + 1
        current_origin[0] -= 1
        current_origin[1] -= 1
        return false if !current_game_board[current_origin[0]][current_origin[1]].empty?
      end
    elsif @destination_coordinates[1] < @origin_coordinates[1] && @destination_coordinates[0] > @origin_coordinates[0]
      until current_origin[1] <= current_destination[1] + 1
        current_origin[0] += 1
        current_origin[1] -= 1
        return false if !current_game_board[current_origin[0]][current_origin[1]].empty?
      end
    end
    true
  end
  
end
