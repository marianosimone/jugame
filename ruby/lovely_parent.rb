# This is a module that lets any class know all its children, so it can return them as a Map (className => class, an Array or a particular one by Name
module LovelyParent
  def self.included(base)
    return unless base.class == Class
    base.extend(LovelyParentClass)
  end

  module LovelyParentClass
    def inherited(subclass)
      subclasses_map[subclass.name.to_sym] = subclass unless subclass.name.empty?
    end

    def get_subclass(name)
      subclasses_map[name.to_sym]
    end

    def subclasses
      subclasses_map.values
    end

    private
    def subclasses_map
      @subclasses ||= {}
    end
  end
end
