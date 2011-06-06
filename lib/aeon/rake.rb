require 'aeon'
require 'rake'

module Aeon
  module Rake
    class Old < ::Rake::TaskLib
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

    class Tag < ::Rake::TaskLib
      def initialize name
        task name do
          raise "Dirty working copy" unless `git status --porcelain`.split("\n").empty?
          sh "git notes --ref=aeon-score add -m \"#{Aeon.score}\""
        end
      end
    end

    class Show < ::Rake::TaskLib
      def initialize
        task :show do
          puts "Aeon score for HEAD `#{`git notes --ref=aeon-score show HEAD`.strip}`"
        end
      end
    end
  end
end

