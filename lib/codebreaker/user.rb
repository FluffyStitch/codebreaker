# frozen_string_literal: true

module Codebreaker
  class User
    attr_accessor :name

    def initialize(name)
      @name = name if validate(name)
    end

    private

    def validate(name)
      /^\w{3,20}$/.match?(name) ? true : (raise TypeError, 'wrong format of input')
    end
  end
end
