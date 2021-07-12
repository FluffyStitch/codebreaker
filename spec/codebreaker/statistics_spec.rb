# frozen_string_literal: true

module Codebreaker
  RSpec.describe Statistics do
    subject(:statistics) { described_class.new(user, difficulty, date) }

    after do
      if Dir.exist?(Settings::DIR) && File.file?(File.join(Settings::DIR, Settings::FILE))
        File.delete(File.join(Settings::DIR, Settings::FILE))
      end
    end

    let(:user) { User.new(FFaker::Name.first_name) }
    let(:difficulty) { Settings::DIFFICULTY.keys.sample.to_s }
    let(:date) { Date.today }

    context 'when save game' do
      let(:file) { YAML.load_file(File.join(Settings::DIR, Settings::FILE)) }

      it 'saved user' do
        statistics.save
        expect(file.first.user.name).to eq(user.name)
      end

      it 'saved difficulty' do
        statistics.save
        expect(file.first.difficulty).to eq(difficulty)
      end

      it 'saved date' do
        statistics.save
        expect(file.first.date).to eq(date)
      end
    end

    describe '#load' do
      before { statistics.save }

      it 'loaded user' do
        expect(described_class.load.first.user.name).to eq(user.name)
      end

      it 'loaded difficulty' do
        expect(described_class.load.first.difficulty).to eq(difficulty)
      end

      it 'loaded date' do
        expect(described_class.load.first.date).to eq(date)
      end
    end
  end
end
