require File.join(File.dirname(__FILE__), "spec_helper" )
module JugaMe
describe GameExecution do

context "game execution being initialized" do
  before(:each) do
    @game = JugaMe::Game.new("The Prissioner's Dilemma",2)
    @game.add_moves(["Stay Silent", "Betray"])
    @game.set_payoff ["Stay Silent", "Stay Silent"], [1, 1]
    @game.set_payoff ["Stay Silent", "Betray"], [10, 0]
    @game.set_payoff ["Betray", "Stay Silent"], [0, 10]
    @game.set_payoff ["Betray", "Betray"], [5, 5]
  end

  it "shouldn't be created if the number of strategies is wrong" do
    lambda{GameExecution.new(@game, [])}.should raise_error JugaMe::InvalidNumberOfStrategiesException
    lambda{GameExecution.new(@game, [nil])}.should raise_error JugaMe::InvalidNumberOfStrategiesException
    lambda{GameExecution.new(@game, [nil,nil,nil])}.should raise_error JugaMe::InvalidNumberOfStrategiesException
  end
end

context "game execution being run" do
  before(:each) do
    game = JugaMe::Game.new("The Prissioner's Dilemma",2)
    game.add_moves(["Stay Silent", "Betray"])
    game.set_payoff ["Stay Silent", "Stay Silent"], [1, 1]
    game.set_payoff ["Stay Silent", "Betray"], [10, 0]
    game.set_payoff ["Betray", "Stay Silent"], [0, 10]
    game.set_payoff ["Betray", "Betray"], [5, 5]
    @execution = GameExecution.new(game, [JugaMe::RandomStrategy.new(game.moves),JugaMe::RandomStrategy.new(game.moves)])
  end

  it "should run as many times as asked to" do
    results = @execution.play(10).individual_results
    results.each{|strategy, result|
      result.moves.size.should be 10
      result.payoffs.size.should be 10
    }
  end
end

end
end
