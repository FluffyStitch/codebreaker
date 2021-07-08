# frozen_string_literal: true

module Codebreaker
  class NoThisDifficultyError < StandardError
    def initialize
      super('Must be easy, medium or hell')
    end
  end
end
