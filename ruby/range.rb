class Range
  def random
    (first + rand(last-first)).floor
  end
end
