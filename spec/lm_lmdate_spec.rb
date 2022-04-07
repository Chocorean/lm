# frozen_string_literal: true

require 'lm'
require 'tempfile'

RSpec.describe LM, '#lmdate' do
  it 'returns the modification time of a file' do
    time = Time.new
    sleep 0.01  # Times are too close otherwise
    Tempfile.create do |f|
      expect(described_class.lmdate(f)).to satisfy("be greater than #{time}") { |t| t >= time }
    end
  end
end
