class Move
  CHAR_CONVERSION = { 'a': 0, 'b': 1, 'c': 2, 'd': 3, 'e': 4, 'f': 5, 'g': 6, 'h': 7 }.freeze

  attr_reader :user_move_string, :origin_coordinates, :origin_cell, :origin_piece, :destination_coordinates, :destination_cell, :destination_piece, :current_game_board, :current_player, :opponent_color, :opponent_player, :game_over

  def initialize(current_game_board, current_player, user_move_string = nil, game_over = false)
    # @current_game_board and @current_player should be the attributes from Game class
    @current_game_board = current_game_board

    @current_player = current_player
    @opponent_color = @current_player.color == 'black' ? 'white' : 'black'
    @opponent_player = Player.new('opponent', @opponent_color.to_s)

    # move is user inputted coordinate String
    @user_move_string = user_move_string

    @origin_coordinates = translate_origin_coordinates(@user_move_string.downcase, CHAR_CONVERSION)
    @destination_coordinates = translate_destination_coordinates(@user_move_string.downcase, CHAR_CONVERSION)

    # this points to the Cell object at these specific coordinates of the Board object's @cells array
    @origin_cell = current_game_board[@origin_coordinates[0]][@origin_coordinates[1]]

    # this points to the Piece object _within_ the square attribute of the aforementioned Cell object
    @origin_piece = @origin_cell.square

    @destination_cell = current_game_board[@destination_coordinates[0]][@destination_coordinates[1]]
    @destination_piece = @destination_cell.square
    # p "dest piece #{@destination_piece}"

    @game_over = game_over
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
  end

  def undo_move
    @origin_cell.square = @origin_piece
    @destination_cell.square = @destination_piece
  end

  def complete_castle(move)
    return unless move.castle?

    if @destination_coordinates[1] == (@origin_coordinates[1] - 2) 
      # move appropriate rook to correct square

      # king's destination + 1 horizontally
      current_game_board[@destination_coordinates[0]][(@destination_coordinates[1] + 1)].square = Piece.new('R', @current_player.color, true)

      # relevant rook's location
      current_game_board[@destination_coordinates[0]][(@destination_coordinates[1] - 2)].square = ' '
    else
      # move kingside rook to correct square
      current_game_board[@destination_coordinates[0]][(@destination_coordinates[1] - 1)].square = Piece.new('R', @current_player.color, true)

      current_game_board[@destination_coordinates[0]][(@destination_coordinates[1] + 1)].square = ' '
    end
  end

  def execute_move
    if @origin_cell.empty?
      puts "Starting square is empty!"
      return false
    end

    new_move = LegalityChecker.new(self, @current_player)

    unless new_move.legal_move?
      puts 'ERROR: Something went wrong.'
      return false
    end

    move_piece
    complete_castle(new_move)

    unless new_move.safe_from_check?(@current_player)
      undo_move
      puts 'Not safe from check.'
      return false
    end

    @origin_piece.promote if promotion?

    # change state of has_moved once move has been finalized here
    @origin_piece.has_moved = true

    checkmate = LegalityChecker.new(self, @current_player).checkmate?
    @game_over = true if checkmate
    puts checkmate ? "Checkmate! #{@current_player.color} wins" : 'not checkmated'
    true
  end

  def promotion?
    # piece type is a pawn and destination square is back rank of opposite color
    return false unless @origin_piece.type == 'P'

    destination = @destination_coordinates[0] == opposite_back_rank

    return destination
  end

  def opposite_back_rank
    @current_player.color == 'black' ? 0 : 7
  end
end
