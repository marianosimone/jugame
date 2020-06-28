require 'observer'

module JugaMe
# Base class for all Strategies, it provides common functionality, like the ability to be notfied about the other players' last actions
class Strategy
  include Observable
  include LovelyParent

  attr_reader :possible_actions, :others_actions

  def initialize(possible_actions)
    @possible_actions = possible_actions
    @checkpoint = false
    @others_actions = []
  end

  def name
    self.class.name
  end

  def play
    res = do_play
    changed && notify_observers(res)
    res
  end

  def last_action_from_other
    others_actions.last
  end

  def update(action_from_other)
    others_actions << action_from_other
  end

  def checkpoint!
    @checkpoint = true
  end

  def checkpointed?
    @checkpoint
  end

end
end
