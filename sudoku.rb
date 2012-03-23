# itintialaises game by creating instance of Board

require './board'

def init_from_file file_name, board
  IO.foreach(file_name) {|line| board.add_line line } 
end

def init_from_command board
  puts "Enter the field line by line using spaces and numbers"
  9.times { |i|
    print "line #{i+1}: "
    line = gets.chop
    until (board.add_line line)
      puts "size #{line.size}"
      puts "line can contain spaces and numbers and must 9 characters long, please try again:"
      print "line #{i+1}: " 
      line = gets.chop
    end
  }
end

puts "Welcome to Sudoku"
board = Board.new

if ARGV.size == 0
  init_from_command board
else
  init_from_file ARGV[0], board
end

puts "The answer is:"
board.resolve
