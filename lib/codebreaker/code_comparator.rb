# frozen_string_literal: true

module Codebreaker
  class CodeComparator
    def initialize(secret_code)
      @secret_code = secret_code
    end

    def guess(user_code)
      validate(user_code)
      secret_code_copy = @secret_code.clone
      user_code.to_i.digits.reverse.map.with_index do |digit, i|
        if secret_code_copy.include?(digit)
          secret_code_copy[secret_code_copy.index(digit)] = nil
          @secret_code[i] == digit ? Settings::PLUS : Settings::MINUS
        end
      end.compact.sort.join
    end

    private

    def validate(code)
      Settings::CODE_REGEX.match?(code) || (raise WrongCodeInputError)
    end
  end
end
