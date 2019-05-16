module TypedRuby
  class Type
    def reduced?
      raise NotImplementedError
    end

    def can_be_assigned_to?(_other)
      raise NotImplementedError
    end
  end
end
