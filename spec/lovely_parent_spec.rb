require File.join(File.dirname(__FILE__), "spec_helper" )

# Just checking that other clasess that include the module don't interfere
class DamnParent 
  include LovelyParent
end
class DamnChild < DamnParent
end
# end checking

# The class to be tested
class AParent
  include LovelyParent
end

describe LovelyParent do
  context "Parent without children" do
    it "Shouldn't have children" do
      number_of_children = AParent.subclasses.size
      number_of_children.should be 0
    end
  end

  context "Parent having children" do
    before(:all) do
      @child_name = "LovedChild"
      @child = Object.const_set(@child_name, Class.new(AParent))
      AParent.inherited(@child) #WORKAROUND, as RSpec doesn't consider the last line as inheritance
    end

    it "Should recognize its children" do
      (AParent.subclasses.include? @child).should be true
    end

    it "Should be able to return its child by name" do
      AParent.get_subclass(@child_name).should eql @child
    end
  end
end
