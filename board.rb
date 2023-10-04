require 'colorize'

class Board
  BACK_PIECES = %w[R N B Q K B N R].freeze

  attr_accessor :cells, :back_row_white, :back_row_black

  def initialize
    # full board minus two back rows added manually later
    @cells = Array.new(6) { Array.new(8) { Cell.new } }
    @back_row_white = BACK_PIECES.map { |piece| Cell.new(Piece.new("#{piece}", 'white')) }
    @back_row_black = BACK_PIECES.map { |piece| Cell.new(Piece.new("#{piece}", 'black')) }
    fill_pieces
  end

  def fill_pawns
    @cells[0].each do |cell|
      cell.square = Piece.new('P', 'white')
    end
    @cells[5].each do |cell|
      cell.square = Piece.new('P', 'black')
    end
  end

  def fill_pieces
    fill_pawns
    @cells.unshift(@back_row_white)
    @cells.push(@back_row_black)
  end

  # maybe add a parameter to print_board for player.color (when you make player class)
  # if i do this i need to figure out how to change calling coordinates on move_piece/translate_move_string
  def print_board
    puts '  ________________________________'
    @cells.each_with_index do |row, id|
      puts "#{id + 1}| #{row.map { |cell| cell.square.to_s }.join(' | ')} |"
      puts ' |___|___|___|___|___|___|___|___|'
    end
    puts '   A   B   C   D   E   F   G   H'
    puts
  end
end
