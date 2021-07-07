# frozen_string_literal: true

module Codebreaker
  class UserCode
    def self.new(code)
      code if validate(code)
    end

    private

    def validate(code)
      /^[1-6]{4}$/.match?(code.to_s) ? true : (raise TypeError, 'wrong format of input')
    end
  end
end
