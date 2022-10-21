require_relative 'connect_four'

describe Player do
  describe "#initialize" do
    context "when Player is initialized" do

      marker = "\u26D4"
      subject(:player1){described_class.new(marker,1)}

      it "is assigned a marker" do
        expect(player1.marker).to eq(marker)
      end

      it "is assigned a number" do
        expect(player1.number).to eq(1)
      end
    end
  end
end

describe Game do

  a = "X"
  b = "O"
  c = " "
  played_board =  [
    [b,a,a,c,c,c], 
    [b,a,a,b,a,c], 
    [b,b,b,a,c,c],
    [b,a,b,b,a,b],  
    [a,a,a,a,b,b],   
    [a,b,b,b,a,c], 
    [b,b,b,a,c,c] ]

  describe "verify_input" do

    subject(:game_input){described_class.new}
    context "when given a valid input as an argument" do
      it "returns a valid number" do
        valid_number = "7"
        result = game_input.verify_input(valid_number)
        expect(result).to eq("7")
      end
    end

    context "when given an invalid input" do
      it "returns nil" do
        invalid_number = "8"
        result = game_input.verify_input(invalid_number)
        expect(result).to be nil
      end
    end
  end

  describe "play_piece" do

    subject(:game_play) {described_class.new}
    let(:player1) {Player.new("X", 1)}
    column_choice = 3
    context "when a piece is played" do
      it "drops to the bottom" do
        
        game_play.play_piece(column_choice, player1)
        updated_column = game_play.board[column_choice -1 ]
        expected_column = ["X", " ", " ", " ", " ", " "]
        expect(updated_column).to eq(expected_column)
      end

      it "drops until it hits a piece" do
        2.times {game_play.play_piece(column_choice, player1)}
        updated_column = game_play.board[column_choice -1 ]
        expected_column = ["X", "X", " ", " ", " ", " "]
        expect(updated_column).to eq(expected_column)
      end

      it "won't be allowed when column is full" do
        6.times {game_play.play_piece(column_choice, player1)}
        game_play.print_board
        expect(game_play).to receive(:puts).with("That column is full.  Try another choice")
        game_play.play_piece(column_choice, player1)
      end
    end
  end

  describe "player_turn" do
    subject(:game_turn){ Game.new}
    context "when player is done" do
      let(:players){ game_turn.create_players}
      it "switches players" do
        player1 = players[0]
        player2 = players[1]
        expect(game_turn.player_turn(player1,players)).to be player2
      end
    end
  end

  describe "extract_positive_diagonal" do
   
    subject(:game_analysis){described_class.new}
    context "when given a piece location" do
      it "will give the diagonal that includes that piece" do
        diagonal = [b,b,b,a,a,c]
        col = 4
        row = 3
        game_analysis.board = played_board
        received_diagonal = game_analysis.extract_positive_diagonal(col,row)
        expect(received_diagonal).to eq(diagonal)
      end
    end
  end

  describe "extract_negative_diagonal" do
  
    subject(:game_analysis){described_class.new}
    context "when given a piece location" do
      it "will give the diagonal that includes that piece" do
        diagonal = [a,a,b,a,a,c]
        col = 4
        row = 3
        game_analysis.board = played_board
        received_diagonal = game_analysis.extract_negative_diagonal(col,row)
        expect(received_diagonal).to eq(diagonal)
      end
    end
  end

  describe "four_in_row?" do
    context "when checking for four in a row" do
      subject(:game_play){described_class.new}
      let(:player1){Player.new("X",1)}
      it "will return true if four in a row" do
        line = ["X","O","X","X","X","X"]
        expect(game_play.four_in_row?(line,player1)).to be true
      end

      it "will return false if not four in a row" do
        line = ["X","O","X","O","X","X"]
        expect(game_play.four_in_row?(line,player1)).to be false
      end
    end
  end

  describe "game_over?" do
    context "when checking a played piece for a win" do
      subject(:game_finished){described_class.new}
      let(:player1){Player.new("X",1)}
      let(:player2){Player.new("O",2)}
      
      it "will return true if 4 in a row horizontally" do
        game_finished.board = played_board
        column = 3
        row = 1
        expect(game_finished.game_over?(column,row,player2)).to be true
      end

      it "will return true if 4 in a row vertically" do
        game_finished.board = played_board
        column = 5
        row = 4
        expect(game_finished.game_over?(column,row,player1)).to be true
      end

      it "will return true if 4 in a row diagonally up" do
        game_finished.board = played_board
        column = 3
        row = 4
        expect(game_finished.game_over?(column,row,player1)).to be true
      end

      it "will return true if 4 in a row diagonally down" do
        game_finished.board = played_board
        column = 5
        row = 5
        expect(game_finished.game_over?(column,row,player1)).to be true
      end

      it "will return false if piece played not four in a row" do
        game_finished.board = played_board
        column = 2
        row = 5
        expect(game_finished.game_over?(column,row,player1)).to be false
      end

    end
  end

end
