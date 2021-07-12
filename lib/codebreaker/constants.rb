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
    WIN = :win
    LOSE = :lose
    IN_PROGRESS = :in_progress
    CODE_LENGTH = 4
    DIR = 'statistics'
    FILE = 'statistics.yml'
    CODE_REGEX = /^[1-6]{4}$/.freeze
    USER_REGEX = /^\w{3,20}$/.freeze
  end
end
