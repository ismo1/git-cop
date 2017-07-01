# frozen_string_literal: true

module Git
  module Cop
    module Reporters
      class Branch
        def initialize collector: Collector.new
          @collector = collector
        end

        def to_s
          "Running #{Identity.label}...#{report}\n#{totals}"
        end

        private

        attr_reader :collector

        def commits
          collector.to_h.reduce("") do |details, (commit, cops)|
            details + Commit.new(commit: commit, cops: cops).to_s
          end
        end

        def report
          return "" if collector.empty?
          "\n\n#{commits}".chomp "\n"
        end

        def totals
          "#{collector.total} issue(s) detected.\n"
        end
      end
    end
  end
end
