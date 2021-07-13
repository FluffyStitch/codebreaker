# frozen_string_literal: true

module Codebreaker
  RSpec.describe Game do
    subject(:game) { described_class.new(user, difficulty) }

    let(:user) { User.new(FFaker::Name.first_name) }
    let(:difficulty) { Settings::DIFFICULTY.keys.sample.to_s }
    let(:user_code) { Array.new(Settings::CODE_LENGTH) { rand(1..6) }.join.to_s }

    context 'when user choose unreal difficulty' do
      let(:difficulty) { FFaker::AnimalUS.common_name }

      it 'raise NoThisDifficultyError' do
        expect { game }.to raise_error(NoThisDifficultyError)
      end
    end

    describe '#guess' do
      context 'when user takes a guess' do
        it 'user has 1 used attempts' do
          game.guess(user_code)
          expect(game.user.attempts_used).to eq(1)
        end

        it 'game in progress status' do
          expect(game.guess(user_code)[:status]).to eq(Settings::IN_PROGRESS)
        end
      end

      context 'when user takes one more after max used' do
        it 'raise NoAttemptsLeftError' do
          Settings::DIFFICULTY[difficulty.to_sym][:attempts].times { game.guess(user_code) }
          expect { game.guess(user_code) }.to raise_error(NoAttemptsLeftError)
        end
      end

      context 'when user win' do
        let(:user_code) { game.secret_code.join.to_s }

        it 'input win message' do
          expect(game.guess(user_code)[:status]).to eq(Settings::WIN)
        end
      end

      context 'when user lose' do
        it 'input lose message' do
          (Settings::DIFFICULTY[difficulty.to_sym][:attempts] - 1).times { game.guess(user_code) }
          expect(game.guess(user_code)[:status]).to eq(Settings::LOSE)
        end
      end
    end

    describe '#hint' do
      context 'when user takes a hint' do
        it 'digit presence in the secret code' do
          expect(game.secret_code.include?(game.hint)).to be true
        end

        it 'user has 1 used hint' do
          game.hint
          expect(game.user.hints_used).to eq(1)
        end
      end

      context 'when user takes one more after max used' do
        it 'raise NoHintsLeftError' do
          Settings::DIFFICULTY[difficulty.to_sym][:hints].times { game.hint }
          expect { game.hint }.to raise_error(NoHintsLeftError)
        end
      end
    end

    describe '#restart' do
      before { game.restart }

      let(:old_user) { game.user }
      let(:old_secret_code) { game.secret_code.join.to_s }

      it 'has same user' do
        expect(game.user).to eq(old_user)
      end

      it 'has new secret code' do
        expect(game.secret_code).not_to eq(old_secret_code)
      end
    end
  end
end
