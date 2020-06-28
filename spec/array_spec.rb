require File.join(File.dirname(__FILE__), "spec_helper" )

describe Array do
context "working with an empty array" do
  before(:each) do
    @array = []
  end

  it "shouldn't return a random element" do
    @array.random.should be nil
  end

  it "should return nothing when asking for combinations" do
    @array.in_groups_of(1).should eql []
    @array.in_groups_of(3).should eql []
  end

  it "shouldn't have a mode" do
    @array.modes.empty?.should be true
  end

  it "should return empty cartesian product" do
    @array.cart_product([1,2]).should be_empty
  end
end

context "working with a single-element array" do
  before(:each) do
    @array = [1]
  end

  it "should return 1 as random element every time" do
    10.times { @array.random.should be 1 }
  end

  it "should return just [1] when asking for combinations" do
    @array.in_groups_of(1).should eql [[1]]
    @array.in_groups_of(3).should eql []
  end

  it "its mode should be the only element" do
    @array.modes.should eql [1]
  end

  it "should return a cartesian product as long as the parameter" do
    product = @array.cart_product([1,2])
    product.size.should be 2
    product.include?([1,1]).should be true
    product.include?([1,2]).should be true
  end
end

context "working with a multiple-elements array (non repetitive)" do
  before(:each) do
    @array = [1,3,4]
  end

  it "should return 1,3 or 4 as random element every time" do
    10.times { ([1,3,4].include? @array.random).should be true }
  end

  it "should return the right ones when asking for combinations" do
    @array.in_groups_of(1).should eql [[1],[3],[4]]
    @array.in_groups_of(2).should eql [[1,3],[1,4],[3,4],[1,1],[3,3],[4,4]]
    @array.in_groups_of(3).should eql [[1,3,4],[1,1,1],[3,3,3],[4,4,4]]
  end

  it "its mode should be the entire array" do
    @array.modes.should eql @array
  end

  it "should return a cartesian product as long as parameter.size*self.size" do
    param = [1,2]
    product = @array.cart_product(param)
    product.size.should be @array.size*param.size
    product.include?([1,1]).should be true
    product.include?([1,2]).should be true
    product.include?([3,1]).should be true
    product.include?([3,2]).should be true
    product.include?([4,1]).should be true
    product.include?([4,2]).should be true
  end

  it "should return an empty cartesian product if the parameter is empty" do
    param = []
    product = @array.cart_product(param)
    product.should be_empty
  end
end

context "working with a multiple-elements array (repetitive)" do
  before(:each) do
    @array = [1,3,1,4]
  end

  it "should return 1,3 or 4 as random element every time" do
    10.times { ([1,3,4].include? @array.random).should be true }
  end

  it "should return the right ones when asking for combinations" do
    @array.in_groups_of(1).should eql [[1],[3],[1],[4]]
    @array.in_groups_of(2).should eql [[1,3],[1,1],[3,1],[1,4],[3,4],[1,4],[1,1],[3,3],[1,1],[4,4]]
    @array.in_groups_of(3).should eql [[1,3,1],[1,3,4],[1,1,4],[3,1,4],[1,1,1],[3,3,3],[1,1,1],[4,4,4]]
  end

  it "its mode should be the repeated value" do
    @array.modes.should eql [1]
  end

  it "should return a cartesian product as long as parameter.size*self.size" do
    param = [1,2]
    product = @array.cart_product(param)
    product.size.should be @array.size*param.size
    product.include?([1,1]).should be true
    product.include?([1,2]).should be true
    product.include?([3,1]).should be true
    product.include?([3,2]).should be true
    product.include?([4,1]).should be true
    product.include?([4,2]).should be true
  end
end
end
