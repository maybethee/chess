require_relative 'game'

def execute_mode(mode_name)
  mode_name.send(player_input)
end

def player_input
  puts "welcome to chess,\n\ntype 'play' to start a new game, or 'continue' to load a saved game."
  loop do
    error_message = "invalid input\n\n"
    mode = gets.chomp
    return mode if valid?(mode.downcase)

    puts error_message
  end
end

def valid?(string)
  %w[continue play].include?(string)
end

game = Game.new
execute_mode(game)