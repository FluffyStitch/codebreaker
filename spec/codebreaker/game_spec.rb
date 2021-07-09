# frozen_string_literal: true

module Codebreaker
  RSpec.describe Game do
    subject(:game) { described_class.new(name, difficulty) }

    let(:name) { FFaker::Name.first_name }
    let(:difficulty) { Settings::DIFFICULTY.keys.sample.to_s }
    let(:user_code) { Array.new(Settings::CODE_LENGTH) { rand(1..6) }.join.to_s }

    context 'when user takes a guess' do
      it 'user has 1 used attempts' do
        game.guess(user_code)
        expect(game.user.attempts_used).to eq(1)
      end
    end

    context 'when user takes a hint' do
      it 'digit presence in the secret code' do
        expect(game.secret_code.include?(game.hint)).to be true
      end

      it 'user has 1 used hint' do
        game.hint
        expect(game.user.hints_used).to eq(1)
      end
    end

    context 'when user takes one more smth after max used' do
      it 'raise NoAttemptsLeftError' do
        Settings::DIFFICULTY[difficulty.to_sym][:attempts].times { game.guess(user_code) }
        expect { game.guess(user_code) }.to raise_error(NoAttemptsLeftError)
      end

      it 'raise NoHintsLeftError' do
        Settings::DIFFICULTY[difficulty.to_sym][:hints].times { game.hint }
        expect { game.hint }.to raise_error(NoHintsLeftError)
      end
    end

    context 'when user win' do
      let(:user_code) { game.secret_code.join.to_s }

      it 'input win message' do
        expect(game.guess(user_code)).to include(Settings::WIN)
      end
    end

    context 'when user lose' do
      it 'input lose message' do
        (Settings::DIFFICULTY[difficulty.to_sym][:attempts] - 1).times { game.guess(user_code) }
        expect(game.guess(user_code)).to include(Settings::LOSE)
      end
    end
  end
end
