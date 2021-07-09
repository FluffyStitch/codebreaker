# frozen_string_literal: true

module Codebreaker
  class User
    attr_reader :name
    attr_accessor :attempts_used, :hints_used

    def initialize(name)
      validate(name)
      @name = name
      @attempts_used = 0
      @hints_used = 0
    end

    private

    def validate(name)
      /^\w{3,20}$/.match?(name) || (raise WrongNameInputError)
    end
  end
end
