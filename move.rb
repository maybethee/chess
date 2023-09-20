class Move
  CHAR_CONVERSION = {"a": 0, 'b': 1, 'c': 2, 'd': 3, 'e': 4, 'f': 5, 'g': 6, 'h': 7}.freeze
  
  attr_accessor :user_move_string, :origin_coordinates, :origin_cell, :origin_piece, :destination_coordinates, :destination_cell, :destination_piece, :current_game_board

  def initialize(current_game_board, user_move_string = nil)
    # @game_board should be the attribute from Game class
    @current_game_board = current_game_board
    
    #move is user inputted coordinate String
    @user_move_string = user_move_string

    # something to test, see if these attributes change accordingly after another move gets made, assuming subsequent moves get made by updating @user_move_string in Move object in #play method.
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
    elsif legal_pawn_move?
      move_piece
    else
      puts 'something else went wrong'
    end
  end

  def legal_pawn_move?
    one_space = pawn_one_space?

    two_spaces = pawn_two_space?

    capture = pawn_capture?

    legal = one_space || two_spaces || capture

    legal
  end

  def pawn_one_space?
    one_space = forward?(1)

    # need to include path_clear? method 

    legal = one_space

  end

  def pawn_two_space?
    first_move = first_move?(@origin_piece)

    two_spaces = forward?(2)

    # need to include path_clear? method
    
    legal = first_move && two_spaces

    legal
  end

  def pawn_capture?
    diagonal = diagonal?(1)

    #this should also specify color, otherwise self-capture will be possible
    has_piece = !@destination_cell.empty?
    
    legal_capture = diagonal && has_piece

    legal_capture
  end


  def first_move?(piece)
    false if piece == ' '
    
    true if piece.has_moved == false
  end

  # forward? also checks backward movement (should probably rename)
  def forward?(spaces)
    true if difference(@origin_coordinates[0], @destination_coordinates[0]) == spaces && difference(@origin_coordinates[1], @destination_coordinates[1]) == 0
  end

  def sideways?(spaces)
    true if difference(@origin_coordinates[1], @destination_coordinates[1]) == spaces && difference(@origin_coordinates[0], @destination_coordinates[0]) == 0
  end

  #make sure this way of checking diagonal movement specifically works with path_clear? check later 
  def diagonal?(spaces)
    true if difference(@origin_coordinates[0], @destination_coordinates[0]) == spaces && difference(@origin_coordinates[1], @destination_coordinates[1]) == spaces
  end

  def difference(a, b)
    (a - b).abs
  end
end
