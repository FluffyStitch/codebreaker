# frozen_string_literal: true

module Codebreaker
  module Settings
    DIFFICULTY = {
      easy: { attempts: 15, hints: 2 },
      medium: { attempts: 10, hints: 1 },
      hell: { attempts: 5, hints: 1 }
    }.freeze
    PLUS = '+'
    MINUS = '-'
    WIN = ' (win)'
    LOSE = ' (lose)'
    CODE_LENGTH = 4
    DIR = 'statistics'
    FILE = 'statistics.yml'
  end
end
