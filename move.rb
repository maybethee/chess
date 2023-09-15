class Move
  CHAR_CONVERSION = {"a": 0, 'b': 1, 'c': 2, 'd': 3, 'e': 4, 'f': 5, 'g': 6, 'h': 7}.freeze
  
  attr_accessor :user_move_string, :origin_coordinates, :origin_symbol, :destination_coordinates, :destination_symbol, :current_game_board

  def initialize(current_game_board, user_move_string = nil)
    # @game_board should be the attribute from Game class
    @current_game_board = current_game_board
    #move is user inputted coordinate String
    @user_move_string = user_move_string
    @origin_coordinates = translate_origin_coordinates(@user_move_string.downcase, CHAR_CONVERSION)
    @origin_symbol = current_game_board[@origin_coordinates[0]][@origin_coordinates[1]].symbol
    @destination_coordinates = translate_dest_coordinates(@user_move_string.downcase, CHAR_CONVERSION)
    @destination_symbol = current_game_board[@destination_coordinates[0]][@destination_coordinates[1]].symbol
  end

    # these methods will go in Board class i suppose? or maybe Game class since the input used in them will likely be received in the Game class... or another class altogether? a Move class??
  def translate_origin_coordinates(coordinate_string, char_int_hash)
    [(coordinate_string[1].to_i - 1), char_int_hash.fetch(coordinate_string[0].to_sym)]
  end

  def translate_dest_coordinates(coordinate_string, char_int_hash)
    [(coordinate_string[3].to_i - 1), char_int_hash.fetch(coordinate_string[2].to_sym)]
  end

  def move_piece
    @current_game_board[@destination_coordinates[0]][@destination_coordinates[1]].symbol = @origin_symbol
    @current_game_board[@origin_coordinates[0]][@origin_coordinates[1]].symbol = ' '    
  end

  def undo_move
    @current_game_board[@origin_coordinates[0]][@origin_coordinates[1]].symbol = @origin_symbol
    @current_game_board[@destination_coordinates[0]][@destination_coordinates[1]].symbol = @destination_symbol
  end
end