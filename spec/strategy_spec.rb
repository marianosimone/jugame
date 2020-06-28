require File.join(File.dirname(__FILE__), "spec_helper" )

class JugaMe::RandomStrategy < JugaMe::Strategy
  def do_play
    possible_actions.random
  end
end

module JugaMe
describe Strategy do

context "strategy created" do
  it "should return something when asked to play" do
    @strategy = JugaMe::RandomStrategy.new ["Stay Silent","Betray"]
    (["Stay Silent", "Betray"].include? @strategy.play).should be true
  end
end
end
end
