# frozen_string_literal: true

module Git
  module Cop
    module Styles
      class CommitBodyBullet < Abstract
        def self.defaults
          {
            enabled: true,
            severity: :error,
            blacklist: %w[* •]
          }
        end

        def valid?
          commit.body_lines.all? { |line| valid_line? line }
        end

        def issue
          return {} if valid?

          {
            label: "Invalid bullet.",
            hint: %(Avoid: #{formatted_blacklist.join ", "}.),
            lines: affected_lines
          }
        end

        private

        def blacklist
          settings.fetch :blacklist
        end

        def formatted_blacklist
          blacklist.map { |bullet| %("#{bullet}") }
        end

        # :reek:FeatureEnvy
        def valid_line? line
          return true if line.strip.empty?
          line.match?(/\A(?!\s*#{Regexp.union blacklist}\s+).+\Z/)
        end

        def affected_lines
          commit.body_lines.each.with_object([]).with_index do |(line, lines), index|
            lines << {number: index + 1, content: line} unless valid_line?(line)
          end
        end
      end
    end
  end
end
