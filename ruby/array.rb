# This depends on the 'random' method for the Range class
class Array
  def random
    index = (0..size).random
    self[index]
  end

  def in_groups_of(number, include_self = true)
    result = self.choose(number)
    self.each {|e| result << [e]*number} unless (not include_self or number < 2 or number > size)
    result
  end

  def choose(k)
    inner_choose(self, k)
  end

  def modes
    modes = []
    histogram = inject(Hash.new(0)) { |h, n| h[n] += 1; h }
    unless histogram.empty?
      sorted = histogram.sort{|x,y| y[1] <=> x[1]}
      histogram.each_pair do |item, times|
        modes << item if times == sorted.first[1]
      end
    end
    modes
  end

  def cart_product(other)
    result = []
    self.each do |self_element|
      other.each do |other_element|
        if self_element.is_a? Array # If we're chaining calls
          tmp = self_element.clone
          tmp << other_element
          result << tmp
        else
          result << [self_element, other_element]
        end
        
      end
    end
    return result
  end

private
  def inner_choose(array,k)
    return [[]] if array.nil? || array.empty? && k == 0
    return [] if array.nil? || array.empty? && k > 0
    return [[]] if array.size > 0 && k == 0
    return [] if k > array.size
    c2 = array.clone
    c2.pop
    new_element = array.clone.pop
    inner_choose(c2, k) + append_all(inner_choose(c2, k-1), new_element)
  end

  def append_all(lists, element)
    lists.map { |l| l << element }
  end
end
