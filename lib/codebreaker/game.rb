# frozen_string_literal: true

module Codebreaker
  class Game
    attr_reader :user, :secret_code

    def initialize(name, difficult)
      @user = User.new(name)
      @difficulty_hash = Settings::DIFFICULTY[difficult.downcase.to_sym]
      generate_code
    end

    def guess(user_code)
      raise NoAttemptsLeftError if @user.attempts_used == @difficulty_hash[:attempts]

      @user.attempts_used += 1
      answer = comparator.guess(user_code)
      if answer.length == Settings::CODE_LENGTH && answer.chars.all?(Settings::PLUS)
        answer << Settings::WIN
      elsif @user.attempts_used == @difficulty_hash[:attempts]
        answer << Settings::LOSE
      else answer
      end
    end

    def hint
      raise NoHintsLeftError if @user.hints_used == @difficulty_hash[:hints]

      @user.hints_used += 1
      @hints.delete_at(@hints.index(@hints.sample))
    end

    def save
      Statistics.new(@user, Settings::DIFFICULTY.key(@difficulty_hash).to_s).save
    end

    def statistics
      Statistics.load
    end

    def restart
      @user.restart
      generate_code
    end

    private

    def comparator
      @comparator ||= CodeComparator.new(@secret_code)
    end

    def generate_code
      @secret_code = Array.new(Settings::CODE_LENGTH) { rand(1..6) }
      @hints = @secret_code.clone
    end
  end
end
