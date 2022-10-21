class Game
  attr_accessor :board

  def initialize
    @board = Array.new(7) {Array.new(6," ")}
  end


  
  def gets_choice 
    puts "Which column would you like to drop your piece?"
    column_choice = gets.chomp
  end

  def verify_input(number)
    return number if number.match?(/^[1-7]$/)
  end

  def play_piece(column, player)
    square_index = board[column - 1].index(" ")
    if square_index.nil?
      puts "That column is full.  Try another choice"
      return
    end
    board[column-1][square_index] = player.marker
    return square_index + 1

  end

  def create_players
    #marker1 = "\u26D4"
    #marker2 = "\u267F"
    marker1 = "X"
    marker2 = "O"
    player1 = Player.new(marker1, 1)
    player2 = Player.new(marker2, 2)
    players = [player1, player2]
  end

  def play
    players = create_players
    player = players[1]
    print_board
    loop do
      player = player_turn(player, players)
      print "Player#{player.number}: "
      column = verify_input(gets_choice).to_i
      row = play_piece(column,player)
      print_board
      break if game_over?(column, row, player)
    end
    winning_message(player)
    new_game if play_again?
      
    
  end

  def new_game
    game = Game.new 
    game.play
  end

  def winning_message(player)
    puts
    puts "Congratulations.  Player#{player.number} won"
  end

  def play_again?
    puts "Do you want to play again? (y/n): "
    answer = gets.chomp
    if answer == "y"
      #game.board = Array.new(7) {Array.new(6," ")}
      #play
      return true
    end
    false
  end

  def player_turn(player, players)
    player.number == 1 ? players[1] : players[0]
    
  end

  def game_over?(col,row, player)
    return true if four_in_row?(extract_horizontal(row), player)
    return true if four_in_row?(extract_vertical(col), player)
    return true if four_in_row?(extract_positive_diagonal(col,row), player) 
    return true if four_in_row?(extract_negative_diagonal(col,row), player)
    false
  end

  def four_in_row?(line, player)
    count = 0
    line.each do | square |
      square == player.marker ? count +=1 : count = 0
      if count >= 4
        #won
        return true
      end
    end
    false
  end


  def extract_vertical(col)
    vertical_array = board[col-1]
  end

  def extract_horizontal(row)
    horizontal_array = []
    7.times do | col |
      horizontal_array.push(board[col][row-1])
    end
    horizontal_array
  end

  def extract_positive_diagonal(col,row)
    diag_array = []
    row -= 1
    col -= 1
    left_col = col - row 
    if left_col.negative?
      row = - left_col
      col = 0
    else
      row = 0
      col = left_col 
    end

    while row < 6 && col < 7 do
      diag_array.push(board[col][row])
      col += 1
      row += 1
    end
    diag_array
  end

  def extract_negative_diagonal(col,row)
    diag_array = []
    row -= 1
    col -= 1
    right_col = col + row
    if right_col > 6
      row = right_col - 6
      col = 6
    else 
      row = 0
      col = right_col
    end

    while row < 6 && col >= 0 do
      diag_array.push(board[col][row])
      col -= 1
      row += 1
    end
    diag_array
  end



  def print_board
    column = "|   "
    line = "+---+---+---+---+---+---+---+"
    puts "  1   2   3   4   5   6   7"
    puts line
    5.downto(0) do | row |     
      7.times do | col |
        print "|" + " #{board[col][row]} " 
      end
      puts "|"
      puts line
    end
  end
end


class Player
  attr_accessor :number, :marker

  def initialize(marker, number)
    @number = number
    @marker = marker
  end
end

game = Game.new
game.play
