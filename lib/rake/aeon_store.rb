require 'aeon'
require 'rake'

module Aeon
  module Rake
    class Task < ::Rake::TaskLib
      attr_reader :tolerance

      def initialize name, &block
        @tolerance = 5

        yield self if block_given?
        
        task name do
          raise "Dependencies too old." if Aeon.score > tolerance
        end
      end

      def tolerate tolerance
        @tolerance = tolerance
      end
    end

    class Store < ::Rake::TaskLib
      def initialize name
        task name do
          raise "Dirty working copy" unless `git status --porcelain`.split("\n").empty?
          Aeon.score
        end
      end
    end
  end
end

