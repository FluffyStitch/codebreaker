# frozen_string_literal: true

require 'yaml'

module Codebreaker
  class Statistics
    DIR = 'statistics'
    FILE = 'statistics.yml'

    class << self
      def save(game)
        statistics = load.is_a?(Array) ? load : []
        statistics << game

        File.open(statistics_path, 'w') { |file| file.write(statistics.to_yaml) }
      end

      def load
        return YAML.load_file(statistics_path) if Dir.exist?(DIR) && File.file?(statistics_path)

        Dir.mkdir(DIR) unless Dir.exist?(DIR)
        nil
      end

      private

      def statistics_path
        File.join(DIR, FILE)
      end
    end
  end
end
