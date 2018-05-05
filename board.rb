# require 'byebug'

class Board
  # represents the entire sudoku board
  attr_accessor :state

  def initialize

    # @state = []
    # for i in 0..8 do
    #   row = []
    #   for j in 0..8 do
    #     row << nil
    #   end
    #   @state << row
    # end
    # get_initial_state

    @state = scaffold_square
  end

  def get_initial_state
    puts "Enter (row, col, value)s and then \"done\""
    line = gets.strip
    while (line != "done")
      (row, col, number) = line.split(',').map(&:to_i)
      @state[row][col] = number

      line = gets.strip
    end
  end

  def print!
    for row in 0..8 do
      for col in 0..8 do
        print(@state[row][col].nil? ? '-' : @state[row][col])
        print(" ") if (col % 3 == 2)
      end
      puts ""
      puts "" if (row % 3 == 2)
    end
  end


  # algorithm
  #
  # find empty square. if no empty squares, game is solved.
  # find legal moves in that square
  #   if no legal moves, this move is not possible. backtrack
  #   else, iterate through legal moves. make move and call recursively
  #
  def solve!
    coords = find_empty_square
    if (coords.nil?)
      return true
    else
      (row, col) = coords

      options = possible_options(row, col)
      if options.empty?
        return false
      end

      for option in options
        @state[row][col] = option
        if solve!
          return true
        else
          @state[row][col] = nil
        end
      end
      return false
    end
  end

  def find_empty_square
    for i in 0..8 do
      for j in 0..8 do
        return [i, j] if @state[i][j].nil?
      end
    end
    return nil
  end

  def possible_options(row, col)
    [1, 2, 3, 4, 5, 6, 7, 8, 9] -
      nums_in_row(row) -
      nums_in_col(col) -
      nums_in_square(row, col)
  end

  def nums_in_row(row)
    @state[row]
  end

  def nums_in_col(col)
    @state.map{ |row| row[col] }
  end

  def nums_in_square(row, col)
    (sq_row, sq_col) = find_square_start(row, col)
    values = []
    for i in 0..2
      for j in 0..2
        values << @state[sq_row + i][sq_col + j]
      end
    end
    values
  end

  def find_square_start(row, col)
    [row / 3 * 3, col / 3 * 3]
  end

  def scaffold_square
    @state = [
      [5, 1, 4, nil, 2, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, 3, 4, nil, nil],
      [6, nil, nil, 7,nil,4,nil,2,nil],
      [nil,nil,3,nil,nil,9,nil,8,nil],
      [nil,nil,6,nil,nil,nil,7,nil,nil],
      [nil,2,nil,4,nil,nil,3,nil,nil],
      [nil,4,nil,8,nil,1,nil,nil,2],
      [nil,nil,1,5,nil,nil,nil,nil,nil],
      [nil,nil,nil,nil,4,nil,nil,7,5]
    ]
  end
end

b = Board.new
puts "Initial board:"
b.print!
b.solve!
puts "Final board:"
b.print!
