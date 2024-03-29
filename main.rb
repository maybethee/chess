require_relative './lib/game'

def execute_mode(mode_name)
  mode_name.send(player_input)
end

def player_input
  puts "WELCOME TO CHESS,\n\nType 'play' to start a new game, or 'continue' to load a saved game."
  loop do
    error_message = "Invalid input.\n\n"
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
