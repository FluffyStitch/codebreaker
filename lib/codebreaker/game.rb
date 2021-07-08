# frozen_string_literal: true

module Codebreaker
  class Game
    def initialize(name, difficult)
      @user = User.new(name)
      @difficulty_hash = Settings::DIFFICULTY[difficult.downcase.to_sym]
      @secret_code = Array.new(Settings::CODE_LENGTH) { rand(1..6) }.join
    end

    def guess(user_code)
      raise NoAttemptsLeftError if @user.attempts_used == @difficulty_hash[:attempts]

      code = UserCode.new(user_code)
      @user.attempts_used += 1
      answer = code.guess(@secret_code)
      if answer.length == Settings::CODE_LENGTH && answer.chars.all?(Settings::PLUS)
        answer << Settings::WIN
      elsif @user.attempts_used == @difficulty_hash[:attempts]
        answer << Settings::LOSE
      else answer
      end
    end

    def hint
      raise NoHintsLeft if @user.hints_used.count == @difficulty_hash[:hints]

      digit = @secret_code[rand(0..3)]
      @user.hints_used.include?(digit) ? hint : (@user.hints_used << digit).last
    end

    def save
      Statistics.new(@user, Settings::DIFFICULTY.key(@difficulty_hash)).save
    end

    def statistics
      Statistics.load
    end
  end
end
