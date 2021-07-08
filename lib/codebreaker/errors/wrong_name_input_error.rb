# frozen_string_literal: true

module Codebreaker
  class WrongNameInputError < StandardError
    def initialize
      super('Length must be from 3 to 20')
    end
  end
end
