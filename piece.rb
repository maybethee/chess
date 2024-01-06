require 'colorize'

class Piece
  attr_accessor :type, :color, :has_moved

  def initialize(type, color, has_moved = false)
    @type = type
    @color = color
    @has_moved = has_moved
  end

  def to_s
    @type.colorize(@color.to_sym)
  end

  def promote
    @type = promotion_input
  end

  def promotion_input
    puts "which piece to promote to? type the letter representing the piece in chess notation:\n\n(Queen = Q, Rook = R, Bishop = B, Knight = N)"

    loop do
      error_message = "invalid type\n\n"
      new_type = gets.chomp
      return new_type.upcase if valid_type?(new_type.downcase)

      puts error_message
    end
  end

  def valid_type?(string)
    !!string.match?(/^[qrbn]$/)
  end
end
