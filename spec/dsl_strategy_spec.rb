require File.join(File.dirname(__FILE__), "spec_helper" )

module JugaMe
describe Strategy do
context "fixed strategy being initialized" do
  it "should have a name and behave as expected" do

    the_strategy "AlwaysA" do
      "A"
    end

    strategy = JugaMe::Strategy.get_subclass("AlwaysA")
    strategy.should_not be_nil
    strategy.name.should eql "AlwaysA"
    playing_strategy = strategy.new(["A","B"])
    playing_strategy.play.should eql "A" 
  end
end

context "depending (tit for tat) strategy being initialized" do
  it "should have a name and behave as expected" do
    
    the_strategy "TitForTat" do |context|
      while_the_other_in context, "A", "A", :and_then => mimic(context)
    end

    strategy = JugaMe::Strategy.get_subclass("TitForTat")
    strategy.should_not be_nil
    strategy.name.should eql "TitForTat"
    playing_strategy = strategy.new(["A","B"])
    playing_strategy.play.should eql "A"
    playing_strategy.update("A")
    playing_strategy.play.should eql "A"
    playing_strategy.update("B")
    playing_strategy.play.should eql "B"
    playing_strategy.update("A")
    playing_strategy.play.should eql "A"
  end
end

context "depending (vendetta) strategy being initialized" do
  it "should have a name and behave as expected" do
    
    the_strategy "Vendetta" do |context|
      while_the_other_in context, "A", "A", :and_then => "B"
    end

    strategy = JugaMe::Strategy.get_subclass("Vendetta")
    strategy.should_not be_nil
    strategy.name.should eql "Vendetta"
    playing_strategy = strategy.new(["A","B"])
    playing_strategy.play.should eql "A"
    playing_strategy.update("A")
    playing_strategy.play.should eql "A"
    playing_strategy.update("B")
    playing_strategy.play.should eql "B"
    playing_strategy.update("A")
    playing_strategy.play.should eql "B"
  end
end

context "depending (copycat) strategy being initialized" do
  it "should have a name and behave as expected" do
    
    the_strategy "Copycat" do |context|
      mimic context
    end

    strategy = JugaMe::Strategy.get_subclass("Copycat")
    strategy.should_not be_nil
    strategy.name.should eql "Copycat"
    playing_strategy = strategy.new(["A","B"])
    playing_strategy.play.should eql "A"
    playing_strategy.update("A")
    playing_strategy.play.should eql "A"
    playing_strategy.update("B")
    playing_strategy.play.should eql "B"
    playing_strategy.update("A")
    playing_strategy.play.should eql "A"
  end
end

context "depending (fashion-victim) strategy being initialized" do
  it "should have a name and behave as expected" do
    
    the_strategy "FashionVictim" do |context|
      mimic_most_used_in context
    end

    strategy = JugaMe::Strategy.get_subclass("FashionVictim")
    strategy.should_not be_nil
    strategy.name.should eql "FashionVictim"
    playing_strategy = strategy.new(["A","B"])
    playing_strategy.play.should eql "A"
    playing_strategy.update("A")
    playing_strategy.play.should eql "A"
    playing_strategy.update("B")
    playing_strategy.play.should eql "A"
    playing_strategy.update("B")
    playing_strategy.play.should eql "B"
    playing_strategy.update("B")
    playing_strategy.play.should eql "B"
    playing_strategy.update("A")
    playing_strategy.play.should eql "B"
    playing_strategy.update("A")
    playing_strategy.play.should eql "A"
  end
end
end
end
