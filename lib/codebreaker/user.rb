# frozen_string_literal: true

module Codebreaker
  class User
    attr_reader :name
    attr_accessor :attempts_used, :hints_used

    def initialize(name)
      validate(name)
      @name = name
      start_new_game
    end

    def start_new_game
      @attempts_used = @hints_used = 0
    end

    private

    def validate(name)
      Settings::USER_REGEX.match?(name) || (raise WrongNameInputError)
    end
  end
end
