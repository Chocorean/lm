# frozen_string_literal: true

require 'lm'

RSpec.describe LM, '#excluded?' do
  context 'without additional patterns' do
    it 'excludes .cache files' do
      expect(described_class.excluded?('file.cache')).to be true
    end

    it 'excludes .log files' do
      expect(described_class.excluded?('file.log')).to be true
    end

    it 'excludes .git files' do
      expect(described_class.excluded?('/path/.git/HEAD')).to be true
    end

    it 'excludes tmp files' do
      expect(described_class.excluded?('/path/tmp/storage')).to be true
    end

    it 'excludes VIM swap files' do
      expect(described_class.excluded?('.README.md.swp')).to be true
    end

    it 'does not exclude the rest' do
      expect(described_class.excluded?('README.md')).to be false
    end
  end

  context 'with additional patterns' do
    patterns = ['\.pyc', '\.o']
    it 'excludes all the added patterns #1' do
      expect(described_class.excluded?('main.pyc', patterns)).to be true
    end

    it 'excludes all the added patterns #2' do
      expect(described_class.excluded?('main.o', patterns)).to be true
    end

    it 'does not excludes other patterns' do
      expect(described_class.excluded?('README.md', patterns)).to be false
    end
  end
end
