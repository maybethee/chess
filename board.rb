require 'colorize'

class Board
  BACK_PIECES = ['R', 'N', 'B', 'K', 'Q', 'B', 'N', 'R'].freeze
  
  attr_accessor :cells, :back_row_white, :back_row_black
  
  def initialize
    # full board minus two back rows added manually later
    @cells = Array.new(6) { Array.new(8) { Cell.new } }
    @back_row_white = BACK_PIECES.map { |piece| Cell.new(piece, 'white') }
    @back_row_black = BACK_PIECES.map { |piece| Cell.new(piece, 'black') }
    fill_pieces
  end
  
  
  def fill_pawns
    @cells[0].each do |cell|
      cell.symbol = 'P'
      cell.color = 'white'
    end
    @cells[5].each do |cell|
      cell.symbol = 'P'
      cell.color = 'black'
    end
  end
  
  def fill_pieces
    fill_pawns
    @cells.unshift(@back_row_white)
    @cells.push(@back_row_black)
  end

  def print_board
    puts '  ________________________________'
    @cells.each_with_index do |row, id|
      puts "#{id + 1}| #{row.each(&:symbol).join(' | ')} |"
      puts ' |___|___|___|___|___|___|___|___|'
    end
    puts '   A   B   C   D   E   F   G   H'
    puts
  end

  # these methods will go in Board class i suppose? or maybe Game class since the input used in them will likely be received in the Game class... or another class altogether? a Move class??
  def translate_origin_coordinates(coordinate_string, char_int_hash)
    [(coordinate_string[1].to_i - 1), char_int_hash.fetch(coordinate_string[0].to_sym)]
  end

  def translate_dest_coordinates(coordinate_string, char_int_hash)
    [(coordinate_string[3].to_i - 1), char_int_hash.fetch(coordinate_string[2].to_sym)]
  end
end