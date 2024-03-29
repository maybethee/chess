class Move
  CHAR_CONVERSION = { 'a': 0, 'b': 1, 'c': 2, 'd': 3, 'e': 4, 'f': 5, 'g': 6, 'h': 7 }.freeze

  attr_accessor :user_move_string, :origin_coordinates, :origin_cell, :origin_piece, :destination_coordinates, :destination_cell, :destination_piece, :current_game_board, :current_player, :opponent_color, :opponent_player, :game_over, :previous_move

  def initialize(current_game_board, current_player, user_move_string = nil, previous_move = nil, game_over = false)

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

    @game_over = game_over

    @previous_move = previous_move
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
      current_game_board[@destination_coordinates[0]][(@destination_coordinates[1] + 1)].square = Piece.new('R', @current_player.color, '♜', true)

      # relevant rook's location
      current_game_board[@destination_coordinates[0]][(@destination_coordinates[1] - 2)].square = ' '
    else
      # move kingside rook to correct square
      current_game_board[@destination_coordinates[0]][(@destination_coordinates[1] - 1)].square = Piece.new('R', @current_player.color, '♜', true)

      current_game_board[@destination_coordinates[0]][(@destination_coordinates[1] + 1)].square = ' '
    end
  end

  def execute_move
    if @origin_cell.empty?
      puts "can't move what's not there!"
      return false
    end

    # new move object using @previous_move string to replace standard user_move_string, getting attribute information from prior move 
    if @previous_move
      previous_move_obj = Move.new(@current_game_board, @current_player, @previous_move)
      new_move = LegalityChecker.new(self, @current_player, previous_move_obj)
    else
      new_move = LegalityChecker.new(self, @current_player)
    end

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

    return true if destination_coordinates[0] == opposite_back_rank
  end

  def opposite_back_rank
    @current_player.color == 'black' ? 0 : 7
  end
end
