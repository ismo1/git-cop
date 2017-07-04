# frozen_string_literal: true

module Git
  module Cop
    module Styles
      class CommitSubjectPrefix < Abstract
        def self.defaults
          {
            enabled: true,
            severity: :error,
            whitelist: %w[Fixed Added Updated Removed Refactored]
          }
        end

        def valid?
          return true if whitelist.empty?
          commit.subject.match?(/\A#{Regexp.union whitelist}/)
        end

        def error
          return "" if valid?
          %(Invalid prefix. Use: #{formatted_whitelist.join ", "}.)
        end

        private

        def whitelist
          settings.fetch :whitelist
        end

        def formatted_whitelist
          whitelist.map { |prefix| %("#{prefix}") }
        end
      end
    end
  end
end
