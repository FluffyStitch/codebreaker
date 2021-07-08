# frozen_string_literal: true

module Codebreaker
  class UserCode
    def initialize(user_code)
      validate(user_code)
      @user_code = user_code.to_s
    end

    def guess(secret_code)
      @secret_code_copy = secret_code.clone
      @user_code.chars.map.with_index do |digit, i|
        if @secret_code_copy.include?(digit)
          @secret_code_copy = delete_digits(digit)
          secret_code[i] == digit ? Settings::PLUS : Settings::MINUS
        else Settings::SPACE
        end
      end.each(&:strip!).sort.join
    end

    private

    def validate(code)
      /^[1-6]{4}$/.match?(code.to_s) || (raise WrongCodeInputError)
    end

    def delete_digits(digit)
      @secret_code_copy.chars.map { |item| item == digit ? Settings::SPACE : item }.join
    end
  end
end
