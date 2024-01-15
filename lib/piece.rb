require 'colorize'

class Piece
  PROMOTION_CONVERSION = { 'R' => '♜', 'N' => '♞', 'B' => '♝', 'Q' => '♛' }.freeze

  attr_accessor :type, :color, :symbol, :has_moved

  def initialize(type, color, symbol, has_moved = false)
    @type = type
    @color = color
    @symbol = symbol
    @has_moved = has_moved
  end

  def to_s
    @symbol.colorize(@color.to_sym)
  end

  def promote
    @type = promotion_input
    @symbol = PROMOTION_CONVERSION.fetch(@type)  
  end

  def promotion_input
    puts "Which piece to promote to? Type the letter representing the piece in chess notation:\n\n(Queen = Q, Rook = R, Bishop = B, Knight = N)"

    loop do
      error_message = "Invalid piece type.\n\n"
      new_type = gets.chomp
      return new_type.upcase if valid_type?(new_type)

      puts error_message
    end
  end

  def valid_type?(string)
    !!string.upcase.match?(/^[QBRN]$/)
  end
end
