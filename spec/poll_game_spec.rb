require File.join(File.dirname(__FILE__), "spec_helper" )

module JugaMe
describe PollGame do

context "Poll Game being initialized" do
  before(:each) do
    @game = JugaMe::Game.new("Going Vacation",3)
    @game.add_moves(["Go To Gral. Belgrano", "Go To Pinamar", "Go To Viedma"])
    @game.extend(JugaMe::PollGame)
  end

  it "should have a name and number of players" do
    @game.name.should eql "Going Vacation"
    @game.number_of_players.should be 3
  end

  it "should allow game poll methods and generate matrix" do
    @game.preference(1, {"Go To Gral. Belgrano" => 3,"Go To Pinamar" => 1,"Go To Viedma" => 2})
    @game.preference(2, {"Go To Gral. Belgrano" => 1,"Go To Pinamar" => 2,"Go To Viedma" => 3})
    @game.preference(3, {"Go To Gral. Belgrano" => 2,"Go To Pinamar" => 3,"Go To Viedma" => 1})
    @game.tie_breaker = 2
    @game.calculate_matrix
    @game.get_payoff(["Go To Gral. Belgrano", "Go To Gral. Belgrano", "Go To Gral. Belgrano"]).should eql [3,1,2]
    @game.get_payoff(["Go To Gral. Belgrano", "Go To Gral. Belgrano", "Go To Pinamar"]).should eql [3,1,2]
    @game.get_payoff(["Go To Gral. Belgrano", "Go To Gral. Belgrano", "Go To Viedma"]).should eql [3,1,2]
    @game.get_payoff(["Go To Gral. Belgrano", "Go To Pinamar", "Go To Gral. Belgrano"]).should eql [3,1,2]
    @game.get_payoff(["Go To Gral. Belgrano", "Go To Pinamar", "Go To Pinamar"]).should eql [1,2,3]
    @game.get_payoff(["Go To Gral. Belgrano", "Go To Pinamar", "Go To Viedma"]).should eql [1,2,3]
    @game.get_payoff(["Go To Gral. Belgrano", "Go To Viedma", "Go To Gral. Belgrano"]).should eql [3,1,2]
    @game.get_payoff(["Go To Gral. Belgrano", "Go To Viedma", "Go To Pinamar"]).should eql [2,3,1]
    @game.get_payoff(["Go To Gral. Belgrano", "Go To Viedma", "Go To Viedma"]).should eql [2,3,1]
    @game.get_payoff(["Go To Pinamar", "Go To Gral. Belgrano", "Go To Gral. Belgrano"]).should eql [3,1,2]
    @game.get_payoff(["Go To Pinamar", "Go To Gral. Belgrano", "Go To Pinamar"]).should eql [1,2,3]
    @game.get_payoff(["Go To Pinamar", "Go To Gral. Belgrano", "Go To Viedma"]).should eql [3,1,2]
    @game.get_payoff(["Go To Pinamar", "Go To Pinamar", "Go To Gral. Belgrano"]).should eql [1,2,3]
    @game.get_payoff(["Go To Pinamar", "Go To Pinamar", "Go To Pinamar"]).should eql [1,2,3]
    @game.get_payoff(["Go To Pinamar", "Go To Pinamar", "Go To Viedma"]).should eql [1,2,3]
    @game.get_payoff(["Go To Pinamar", "Go To Viedma", "Go To Gral. Belgrano"]).should eql [2,3,1]
    @game.get_payoff(["Go To Pinamar", "Go To Viedma", "Go To Pinamar"]).should eql [1,2,3]
    @game.get_payoff(["Go To Pinamar", "Go To Viedma", "Go To Viedma"]).should eql [2,3,1]
    @game.get_payoff(["Go To Viedma", "Go To Gral. Belgrano", "Go To Gral. Belgrano"]).should eql [3,1,2]
    @game.get_payoff(["Go To Viedma", "Go To Gral. Belgrano", "Go To Pinamar"]).should eql [3,1,2]
    @game.get_payoff(["Go To Viedma", "Go To Gral. Belgrano", "Go To Viedma"]).should eql [2,3,1]
    @game.get_payoff(["Go To Viedma", "Go To Pinamar", "Go To Gral. Belgrano"]).should eql [1,2,3]
    @game.get_payoff(["Go To Viedma", "Go To Pinamar", "Go To Pinamar"]).should eql [1,2,3]
    @game.get_payoff(["Go To Viedma", "Go To Pinamar", "Go To Viedma"]).should eql [2,3,1]
    @game.get_payoff(["Go To Viedma", "Go To Viedma", "Go To Gral. Belgrano"]).should eql [2,3,1]
    @game.get_payoff(["Go To Viedma", "Go To Viedma", "Go To Pinamar"]).should eql [2,3,1]
    @game.get_payoff(["Go To Viedma", "Go To Viedma", "Go To Viedma"]).should eql [2,3,1]
  end

  it "should raise an exception if there's no tie-breaker" do
    @game.preference(1, {"Go To Gral. Belgrano" => 3,"Go To Pinamar" => 1,"Go To Viedma" => 2})
    @game.preference(2, {"Go To Gral. Belgrano" => 1,"Go To Pinamar" => 2,"Go To Viedma" => 3})
    @game.preference(3, {"Go To Gral. Belgrano" => 2,"Go To Pinamar" => 3,"Go To Viedma" => 1})
    lambda{@game.calculate_matrix}.should raise_error JugaMe::NoTieBreakerInPollException
  end

  it "should raise an exception when setting and invalid tie-breaker" do
    lambda{@game.tie_breaker = 4}.should raise_error JugaMe::UnknownPlayerException
  end

  it "should raise an exception if preferences are not complete" do
    @game.preference(1, {"Go To Gral. Belgrano" => 3,"Go To Pinamar" => 1,"Go To Viedma" => 2})
    @game.preference(2, {"Go To Gral. Belgrano" => 1,"Go To Pinamar" => 2,"Go To Viedma" => 3})
    @game.tie_breaker = 2
    lambda{@game.calculate_matrix}.should raise_error JugaMe::IncompletePollPreferencesException
  end

  it "should raise an exception if trying to insert a preference for a non-existen player" do
    lambda{@game.preference(0, {"Go To Gral. Belgrano" => 3,"Go To Pinamar" => 1,"Go To Viedma" => 2})}.should raise_error JugaMe::UnknownPlayerException
  end

  it "should raise an exception if trying to insert a preference with an unknown move" do
    lambda{@game.preference(1, {"Go To Gral. Fail" => 3,"Go To Pinamar" => 1,"Go To Viedma" => 2})}.should raise_error JugaMe::UnknownMoveException
  end
end

end
end
