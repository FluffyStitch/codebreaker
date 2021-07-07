# frozen_string_literal: true

module Codebreaker
  class Difficulty
    def self.new(difficult)
      {
        easy: { attempts: 15, hints: 2 },
        medium: { attempts: 10, hints: 1 },
        hell: { attempts: 5, hints: 1 }
      }[difficult.downcase.to_sym]
    end
  end
end
