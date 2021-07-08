# frozen_string_literal: true

module Codebreaker
  class WrongCodeInputError < StandardError
    def initialize
      super('Must 4-digit number, each digit in the range 1-6')
    end
  end
end
