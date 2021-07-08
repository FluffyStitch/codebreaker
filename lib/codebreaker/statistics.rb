# frozen_string_literal: true

module Codebreaker
  class Statistics
    attr_reader :name, :difficulty, :attempts_total, :attempts_used, :hints_total, :hints_used, :date

    def initialize(user, difficulty, date = Date.now)
      @name = user.name
      @difficulty = difficulty.to_s.capitalize
      @attempts_total = Settings::DIFFICULTY[difficulty][:attempts]
      @attempts_used = user.attempts_used
      @hints_total = Settings::DIFFICULTY[difficulty][:hints]
      @hints_used = user.hints_used.count
      @date = date
    end

    def save
      statistics = self.class.load << self

      File.open((self.class.send :statistics_path), 'w') { |file| file.write(statistics.to_yaml) }
    end

    class << self
      def load
        if Dir.exist?(Settings::DIR) && File.file?(statistics_path)
          statistics = YAML.load_file(statistics_path)
          return sort_difficulty(statistics)
        end

        Dir.mkdir(Settings::DIR) unless Dir.exist?(Settings::DIR)
        []
      end

      private

      def statistics_path
        File.join(Settings::DIR, Settings::FILE)
      end

      def sort_difficulty(statistics)
        statistics.sort_by do |statistic|
          [statistic.attempts_total, statistic.hints_total, statistic.attempts_used, statistic.hints_used]
        end
      end
    end
  end
end
