class Object
def the_strategy(name, &block)
    klass = Object.const_set(name, Class.new(JugaMe::Strategy))
    JugaMe::Strategy.inherited(klass) #WORKAROUND, as RSpec doesn't consider the last line as inheritance
    klass.send :class_variable_set, :@@actual_play, block
    klass.class_eval do
      def do_play
        block = self.class.send :class_variable_get,:@@actual_play
        block.call(self)
      end
    end
  end

  def while_the_other_in(context, condition, default, action)
    action = action.is_a?(Hash) ? action[:and_then] : action
    return default if context.last_action_from_other.nil? #Start nicely
    if (not context.checkpointed? and context.last_action_from_other == condition)
      return default
    else
      context.checkpoint!
      return action
    end
  end

  def mimic(context)
    context.last_action_from_other.nil? ? context.possible_actions.first : context.last_action_from_other
  end

  def mimic_most_used_in(context)
    context.others_actions.modes.first || context.possible_actions.first
  end
end
