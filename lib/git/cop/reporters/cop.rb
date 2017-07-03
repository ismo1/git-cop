# frozen_string_literal: true

module Git
  module Cop
    module Reporters
      class Cop
        def initialize cop
          @cop = cop
          @issue = cop.issue
        end

        def to_s
          "  #{cop.class.label}: #{issue.fetch(:label)} #{issue.fetch(:hint)}\n#{affected_lines}"
        end

        private

        attr_reader :cop, :issue

        # :reek:FeatureEnvy
        def affected_lines
          issue.fetch(:lines, []).reduce "" do |lines, line|
            lines + "    Line #{line.fetch :number}: #{line.fetch :content}\n"
          end
        end
      end
    end
  end
end
