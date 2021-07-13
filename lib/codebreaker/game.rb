# frozen_string_literal: true

module Codebreaker
  class Game
    attr_reader :user, :secret_code

    def initialize(user, difficulty)
      @user = user
      @difficulty_attributes = Settings::DIFFICULTY[difficulty.downcase.to_sym] || (raise NoThisDifficultyError)
      generate_code
    end

    def guess(user_code)
      raise NoAttemptsLeftError if @user.attempts_used == @difficulty_attributes[:attempts]

      answer = @comparator.guess(user_code)
      @user.attempts_used += 1
      status = if answer == Settings::PLUS * Settings::CODE_LENGTH
                 Settings::WIN
               elsif @user.attempts_used == @difficulty_attributes[:attempts]
                 Settings::LOSE
               else Settings::IN_PROGRESS
               end
      { answer: answer, status: status }
    end

    def hint
      raise NoHintsLeftError if @user.hints_used == @difficulty_attributes[:hints]

      @user.hints_used += 1
      @hints.pop
    end

    def save
      Statistics.new(@user, Settings::DIFFICULTY.key(@difficulty_attributes).to_s).save
    end

    def statistics
      Statistics.load
    end

    def restart
      @user.start_new_game
      generate_code
    end

    private

    def generate_code
      @secret_code = Array.new(Settings::CODE_LENGTH) { rand(1..6) }
      @hints = @secret_code.clone.shuffle
      @comparator = CodeComparator.new(@secret_code)
    end
  end
end
