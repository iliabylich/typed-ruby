require 'parser/ruby25'

module TypedRuby
  module AST
    class RubyParser
      def initialize(file:, source:)
        @parser = ::Parser::Ruby25.new
        @buffer = ::Parser::Source::Buffer.new(file)
        @buffer.source = source
      end

      def parse
        @parser.parse(@buffer)
      end

      def self.parse_file(filepath)
        new(file: filepath, source: File.read(filepath)).parse
      end

      def self.parse_files(filepaths)
        filepaths.map { |filepath| parse_file(filepath) }
      end
    end
  end
end
