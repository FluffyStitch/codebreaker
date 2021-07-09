# frozen_string_literal: true

module Codebreaker
  RSpec.describe User do
    subject(:user) { described_class.new(name) }

    let(:name) { FFaker::Name.first_name }
    let(:attempts_used) { 0 }
    let(:hints_used) { 0 }

    describe '.initialize' do
      it 'initializes' do
        expect(user).to be_a(described_class)
      end
    end

    context 'when name is valid' do
      it 'has name' do
        expect(user.name).to eq(name)
      end

      it 'has 0 attempts used' do
        expect(user.attempts_used).to eq(attempts_used)
      end

      it 'has 0 hints used' do
        expect(user.hints_used).to eq(hints_used)
      end
    end

    context 'when name is not valid' do
      let(:name) { '' }

      it 'raise WrongNameInputError' do
        expect { user }.to raise_error(WrongNameInputError)
      end
    end

    context 'when user data restart' do
      before do
        user.attempts_used += 1
        user.hints_used += 1
        user.start_new_game
      end

      it 'has 0 attempts used' do
        expect(user.attempts_used).to eq(attempts_used)
      end

      it 'has 0 hints used' do
        expect(user.hints_used).to eq(hints_used)
      end
    end
  end
end
