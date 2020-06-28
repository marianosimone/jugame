require File.join(File.dirname(__FILE__), "spec_helper" )

module JugaMe
describe Game do

context "game correctly initialized" do
  it "should have a name, players and a correct payoff matrix (2 players)" do

    in_the_game "The Prissioner's Dilemma", 2.players do
      choose_to "Betray"
      choose_to "Stay Silent"
      when_their_choices_are "Betray", "Betray", they_pay = 5
      when_their_choices_are "Stay Silent", "Stay Silent", they_pay = 1
      when_their_choices_are "Stay Silent", "Betray", they_pay = 10, 0
      when_their_choices_are "Betray", "Stay Silent", they_pay = 0, 10
    end

    game = JugaMe::Game.games["The Prissioner's Dilemma"]
    game.should_not be_nil
    game.name.should eql "The Prissioner's Dilemma"
    game.number_of_players.should be 2
    game.moves.length.should be 2
    game.get_payoff(["Betray","Betray"]).should eql [5,5]
    game.get_payoff(["Stay Silent","Stay Silent"]).should eql [1,1]
    game.get_payoff(["Stay Silent","Betray"]).should eql [10,0]
    game.get_payoff(["Betray","Stay Silent"]).should eql [0,10]
  end
end

context "poll game correctly initialized" do
  it "should have a name, players and payoff matrix (2 players)" do

    in_the_game "The TV Couple", 2.players do
      vote_to "Watch a Movie"
      vote_to "Watch a Reallity Show"
      player 1, :prefers_to => ["Watch a Movie"]
      player 2, :prefers_to => ["Watch a Reallity Show"]
      tie_breaker_is 1
    end

    game = JugaMe::Game.games["The TV Couple"]
    game.should_not be_nil
    game.name.should eql "The TV Couple"
    game.number_of_players.should be 2
    game.moves.length.should be 2
    game.get_payoff(["Watch a Movie","Watch a Movie"]).should eql [1,0]
    game.get_payoff(["Watch a Movie","Watch a Reallity Show"]).should eql [1,0]
    game.get_payoff(["Watch a Reallity Show","Watch a Movie"]).should eql [0,1]
    game.get_payoff(["Watch a Reallity Show","Watch a Reallity Show"]).should eql [0,1]
  end
end

context "game incorrectly initialized" do
  it "should fail when the matrix is not complete" do
    @exception = nil
    begin
    in_the_game "The Prissioner's Dilemma", 2.players do
      choose_to "Betray"
      choose_to "Stay Silent"
      when_their_choices_are "Betray", "Betray", they_pay = 5
      when_their_choices_are "Stay Silent", "Stay Silent", they_pay = 1
      when_their_choices_are "Stay Silent", "Betray", they_pay = 10, 0
    end
    rescue JugaMe::InvalidPayoffMatrixException => e
      @exception = e
    end
    @exception.should_not be nil
    JugaMe::Game.games["The Prissioner's Dilemma"].should be nil
  end
end

end
end
