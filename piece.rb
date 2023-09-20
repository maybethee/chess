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
end
