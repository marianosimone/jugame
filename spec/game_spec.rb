require File.join(File.dirname(__FILE__), "spec_helper" )

module JugaMe
describe Game do

context "game being initialized" do
  before(:each) do
    @game = JugaMe::Game.new("The Prissioner's Dilemma",2)
  end

  it "should have a name and number of players" do
    @game.name.should eql "The Prissioner's Dilemma"
    @game.number_of_players.should be 2
  end

  it "should change its moves when asked to" do
    @game.add_moves(["Stay Silent", "Betray"])
    @game.moves.length.should be 2
    @game.moves.should eql ["Stay Silent", "Betray"]
    @game.add_moves("Shoot")
    @game.moves.length.should be 3
    @game.moves.should eql ["Stay Silent", "Betray", "Shoot"]
  end

  it "should return values according to its payoff matrix (2 options, 2 players)" do
    @game.add_moves(["Stay Silent", "Betray"])
    @game.set_payoff ["Stay Silent", "Stay Silent"], [1, 1]
    @game.set_payoff ["Stay Silent", "Betray"], [10, 0]
    @game.set_payoff ["Betray", "Stay Silent"], [0, 10]
    @game.set_payoff ["Betray", "Betray"], [5, 5]

    @game.get_payoff(["Stay Silent", "Stay Silent"]).should eql [1,1]
    @game.get_payoff(["Stay Silent", "Betray"]).should eql [10,0]
    @game.get_payoff(["Betray", "Stay Silent"]).should eql [0,10]
    @game.get_payoff(["Betray", "Betray"]).should eql [5,5]
  end

  it "should raise an exception when the payoffs are set for less players than the playing ones" do
    @game.add_moves(["Stay Silent", "Betray"])
    lambda{@game.set_payoff ["Stay Silent", "Stay Silent"], [1]}.should raise_error JugaMe::InvalidPayoffException
    lambda{@game.set_payoff ["Stay Silent", "Stay Silent"], [1,2,3]}.should raise_error JugaMe::InvalidPayoffException
    lambda{@game.set_payoff ["Stay Silent", "Stay Silent", "Betray"], [2,3]}.should raise_error JugaMe::InvalidPayoffException
  end

  it "should raise an exception when an unknown move is send to set_payoff" do
    @game.add_moves(["Stay Silent", "Betray"])
    lambda{@game.set_payoff ["Stay Silent", "Shoot"], [1,2]}.should raise_error JugaMe::UnknownMoveException
  end
end

context "game correctly initialized" do
  before(:each) do
    @game = JugaMe::Game.new("The Prissioner's Dilemma",2)
    @game.add_moves(["Stay Silent", "Betray"])
    @game.set_payoff ["Stay Silent", "Stay Silent"], [1, 1]
    @game.set_payoff ["Stay Silent", "Betray"], [10, 0]
    @game.set_payoff ["Betray", "Stay Silent"], [0, 10]
    @game.set_payoff ["Betray", "Betray"], [5, 5]
  end

  it "should raise an exception when asking for a payoff with different moves than needed" do
    lambda{@game.get_payoff ["Stay Silent", "Betray", "Betray"]}.should raise_error JugaMe::InvalidPayoffException
    lambda{@game.get_payoff ["Stay Silent"]}.should raise_error JugaMe::InvalidPayoffException
  end

  it "should raise an exception when an unknown move is send to get_payoff" do
    lambda{@game.get_payoff ["Stay Silent", "Shoot"]}.should raise_error JugaMe::UnknownMoveException
  end
end

end
end
