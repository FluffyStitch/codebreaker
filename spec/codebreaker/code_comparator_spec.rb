# frozen_string_literal: true

module Codebreaker
  RSpec.describe CodeComparator do
    subject(:code_comparator) { described_class.new(secret_code) }

    let(:codes_hash) do
      [
        { secret_code: [6, 5, 4, 3], guess: '5643', result: '++--' },
        { secret_code: [6, 5, 4, 3], guess: '6411', result: '+-' },
        { secret_code: [6, 5, 4, 3], guess: '6544', result: '+++' },
        { secret_code: [6, 5, 4, 3], guess: '3456', result: '----' },
        { secret_code: [6, 5, 4, 3], guess: '6666', result: '+' },
        { secret_code: [6, 5, 4, 3], guess: '2666', result: '-' },
        { secret_code: [6, 5, 4, 3], guess: '2222', result: '' },
        { secret_code: [6, 6, 6, 6], guess: '1661', result: '++' },
        { secret_code: [1, 2, 3, 4], guess: '3124', result: '+---' },
        { secret_code: [1, 2, 3, 4], guess: '1524', result: '++-' },
        { secret_code: [1, 2, 3, 4], guess: '1234', result: '++++' }
      ]
    end
    let(:secret_code) { codes_hash[0][:secret_code] }

    context 'when user code is not valid' do
      let(:guess) { '18' }

      it 'raise WrongCodeInputError' do
        expect { code_comparator.guess(guess) }.to raise_error(WrongCodeInputError)
      end
    end

    context 'when params is valid' do
      let(:comparator_results) { [] }
      let(:results) do
        results = []
        codes_hash.each { |codes| results << codes[:result] }
        results
      end

      it 'success' do
        codes_hash.each { |codes| comparator_results << described_class.new(codes[:secret_code]).guess(codes[:guess]) }
        expect(comparator_results).to eq(results)
      end
    end
  end
end
