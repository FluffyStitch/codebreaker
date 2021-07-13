# frozen_string_literal: true

module Codebreaker
  class Statistics
    attr_reader :user, :difficulty, :attempts_total, :hints_total, :date

    def initialize(user, difficulty, date = Date.today)
      @user = user
      @difficulty = difficulty
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
          [Settings::DIFFICULTY[statistic.difficulty.to_sym][:attempts],
           Settings::DIFFICULTY[statistic.difficulty.to_sym][:hints],
           statistic.user.attempts_used, statistic.user.hints_used]
        end
      end
    end
  end
end
