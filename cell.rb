require 'colorize'

class Cell
  attr_accessor :symbol, :color

  def initialize(symbol = ' ', color = nil)
    @symbol = symbol
    @color = color
  end 

  def to_s
    if @color.nil?
      @symbol
    else
      @symbol.colorize(@color.to_sym)
    end
  end
end