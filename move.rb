class Move
  CHAR_CONVERSION = { "a": 0, 'b': 1, 'c': 2, 'd': 3, 'e': 4, 'f': 5, 'g': 6, 'h': 7 }.freeze

  attr_reader :user_move_string, :origin_coordinates, :origin_cell, :origin_piece, :destination_coordinates, :destination_cell, :destination_piece, :current_game_board, :current_player

  def initialize(current_game_board, current_player, user_move_string = nil)
    # @current_game_board and @current_player should be the attributes from Game class
    @current_game_board = current_game_board
    @current_player = current_player
    
    #move is user inputted coordinate String
    @user_move_string = user_move_string

    @origin_coordinates = translate_origin_coordinates(@user_move_string.downcase, CHAR_CONVERSION)
    @destination_coordinates = translate_destination_coordinates(@user_move_string.downcase, CHAR_CONVERSION)

    # this points to the Cell object at these specific coordinates of the Board object's @cells array
    @origin_cell = current_game_board[@origin_coordinates[0]][@origin_coordinates[1]]

    # this points to the Piece object _within_ the square attribute of the aforementioned Cell object
    @origin_piece = @origin_cell.square

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
      return false
    elsif LegalityChecker.new(self, @current_player).legal_move?
      move_piece
      return true
    else
      puts 'something else went wrong'
      return false
    end
  end    
end
