# frozen_string_literal: true

module Git
  module Cop
    module Styles
      class CommitBodyPresent < Abstract
        def self.defaults
          {
            enabled: false,
            severity: :error,
            minimum: 1
          }
        end

        def valid?
          valid_lines = commit.body_lines.reject { |line| line.match?(/^\s*$/) }
          valid_lines.size >= minimum
        end

        def minimum
          settings.fetch :minimum
        end

        def issue
          return "" if valid?

          "Write at least #{minimum} non-empty line#{"s" if minimum > 1} in" \
          " your commit body."
        end
      end
    end
  end
end
