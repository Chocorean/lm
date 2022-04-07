# frozen_string_literal: true

require 'optparse'
require_relative 'lm'

options = {
  exclude: [],
  include_all: false,
  ignore_errors: false,
  lines: 5
}

OptionParser.new do |parser|
  parser.banner = <<-BANNER
    lm [OPTION]... [FILE]...
    List last modified FILEs (the current directory by default).
    Sort entries by most recent modification date.

    Options:
  BANNER

  parser.on('-a', '--include-all', 'Include all files excluded by default') do
    options[:include_all] = true
  end
  parser.on('-e', '--exclude PATTERN...', Array, 'Exclude regex patterns from search') do |patterns|
    patterns.each { |p| options[:exclude] << p }
  end
  parser.on('-I', '--ignore-errors', 'Skip FILEs if they do not exist') do
    options[:ignore_errors] = true
  end
  parser.on('-n', '--lines NUM', Integer, 'Output the last NUM lines, instead of the ' \
                                          "last #{options[:lines]}.") do |lines|
    options[:lines] = lines
  end
end.parse!

dirs = ARGV.empty? ? ['.'] : ARGV
entries = LM.start options, dirs
entries.show
