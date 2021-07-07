# frozen_string_literal: true

module Codebreaker
  class SecretCodeGenerator
    CODE_LENGTH = 4

    def self.new
      @secret_code = ''
      CODE_LENGTH.times { @secret_code << rand(1..6).to_s }
      @secret_code
    end
  end
end
