# frozen_string_literal: true

require 'difficulty'
require 'secret_code'
require 'user'
require 'user_code'
require 'statistics'

module Codebreaker
  class Game
    def initialize(name, difficult)
      difficulty_hash = Difficulty.new(difficult)
      @difficulty = difficult
      @name = name
      @attemts_total = difficulty_hash[:attempts]
      @attemts_used = 0
      @hints_total = difficulty_hash[:hints]
      @hints_used = []
      @secret_code = SecretCodeGenerator.new
      @answer = '  '
    end

    def guess(user_code)
      @attemts_used += 1 # if state == :in_progress
      @answer = UserCode.validate(user_code).to_s.chars.each_with_index.map do |digit, i|
        if @secret_code[i] == digit
          '+'
        else
          @secret_code.include?(digit) ? '-' : ' '
        end
      end.join
    end

    def hint
      raise StandardError, 'no hints left' if @hints_used.count == @hints_total

      digit = @secret_code[rand(0..3)]
      @hints_used.include?(digit) ? hint : (@hints_used << digit).last
    end

    def state
      return :win if @answer.chars.all?('+')

      @attemts_used == @attemts_total ? (return :lose) : (return :in_progress)
    end

    def save
      Statistics.save(self)
    end

    def statistics
      Statistics.load
    end
  end
end
