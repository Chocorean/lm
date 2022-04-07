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
baz = create_file 'baz'

default_options = {
  exclude: [],
  include_all: false,
  ignore_errors: false,
  lines: 5
}

begin
  RSpec.describe LM, '#start' do
    context 'with default options' do
      entries = described_class.start default_options, [TMPDIR]
      it 'returns three files' do
        expect(entries.size).to eq 3
      end

      output = catch_stdout { entries.show }
      it 'returns files sorted by mtime' do
        expect(output[1] =~ /.*bar/).not_to be_nil
      end
    end
  end
ensure
  delete_file foo
  delete_file bar
  delete_file baz
  `rmdir #{TMPDIR}`
end
