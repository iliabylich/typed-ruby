module TypedRuby
  module Signatures
    class Arguments
      class Base
        attr_reader :name, :type

        def initialize(name:, type:)
          @name = name
          @type = type
        end
      end
    end
  end
end
