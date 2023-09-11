class Board
  attr_accessor :cells, :back_row
  
  def initialize
    # full board minus two back rows added manually later
    @cells = Array.new(6) { Array.new(8) { Cell.new } }
    @back_row = [Cell.new('R'), Cell.new('N'), Cell.new('B'), Cell.new('K'), Cell.new('Q'), Cell.new('B'), Cell.new('N'), Cell.new('R')]
  end
  
  def fill_pawns
    @cells[0].each do |cell|
      cell.symbol = 'P'
    end
    @cells[5].each do |cell|
      cell.symbol = 'P'
    end
  end
  
  def fill_pieces
    fill_pawns
    @cells.unshift(@back_row)
    @cells.push(@back_row)
  end

  def print_board
    puts '  ________________________________'
    @cells.each_with_index do |row, id|
      puts "#{id + 1}| #{row.map(&:symbol).join(' | ')} |"
      puts ' |___|___|___|___|___|___|___|___|'
    end
    puts '   A   B   C   D   E   F   G   H'
    puts
  end
end
