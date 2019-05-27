module TypedRuby
  class Type
    def initialize(name:)
      @name = name
    end

    def find_method(*)
      raise NotImplementedError
    end

    def inspect
      "<Abstract Type #{name}>"
    end
  end
end
