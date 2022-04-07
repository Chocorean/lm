# frozen_string_literal: true

require 'lm'
require 'tempfile'

TMPDIR = 'temp_rspec'
`mkdir #{TMPDIR}`

def create_file(name)
  f = Tempfile.new name, TMPDIR
  sleep 0.01
  f
end

def delete_file(file)
  file.close
  file.unlink
end

def catch_stdout
  original_stdout = $stdout
  $stdout = StringIO.new
  yield
  $stdout.string.split
ensure
  $stdout = original_stdout
end

foo = create_file 'foo'
bar = create_file 'bar'
ign = create_file '.git'
baz = create_file 'baz'

default_options = {
  exclude: [],
  include_all: false,
  ignore_errors: false,
  lines: 5
}

RSpec.describe LM, '#start' do
  context 'with default options' do
    entries = described_class.start default_options, [TMPDIR]
    it 'returns three files' do
      expect(entries.size).to eq 3
    end

    it 'returns files sorted by mtime' do
      output = catch_stdout { entries.show }
      expect(output[1] =~ /.*bar/).not_to be_nil
    end

    it 'fails if FILE does not exist' do
      described_class.start default_options, ['/does/not/exist']
    rescue SystemExit => e
      expect(e.status).to eq 1
    end
  end

  context 'with --lines option' do
    options = default_options.clone
    options[:lines] = 1
    entries = described_class.start options, [TMPDIR]
    it 'only returns one file' do
      output = catch_stdout { entries.show }
      expect(output.size).to eq 1
    end
  end

  context 'with --ignore-errors option' do
    options = default_options.clone
    options[:ignore_errors] = true
    entries = described_class.start options, ['/does/not/exist', TMPDIR]
    it 'ignores the missing files' do
      expect(entries.size).to eq 3
    end
  end

  context 'with --include-all option' do
    options = default_options.clone
    options[:include_all] = true
    entries = described_class.start options, [TMPDIR]
    it 'includes ignored-by-default files' do
      expect(entries.size).to be 4
    end
  end
end

delete_file foo
delete_file bar
delete_file ign
delete_file baz
`rmdir #{TMPDIR}`
