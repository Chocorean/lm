# frozen_string_literal: true

require 'find'

# LastModified module
module LM
  # Return true if file matches regex of excluded filetypes
  def self.excluded?(file, options = {})
    return false if options[:include_all]

    patterns = options[:exclude] || []
    regex = [
      /\.cache$/, /\.log$/, /\.git/, /tmp/, /\.sw[a-p]$/
    ]
    patterns.each { |p| regex << /#{p}/ }
    regex.each do |r|
      return true if file =~ r
    end
    false
  end

  # Return Date of last modification of a file described by its path
  def self.lmdate(file)
    File.mtime(file)
  end

  # Bootstrap method
  # Doc says arguments are FILEs, but treating them as directories anyway
  def self.start(options, dirs)
    entries = List.new options
    dirs.each do |dir|
      Find.find(dir) do |file|
        next unless File.file?(file) && !LM.excluded?(file, options)

        entries.add file
      end
    rescue Errno::ENOENT
      unless options[:ignore_errors]
        warn "lm: cannot access #{dir}: No such file or directory"
        exit 1
      end
      next
    end
    entries
  end

  # Handles an ordered list of last modified files
  # List is sorted by ascending order, which means the last element is the
  #   last which has been modified.
  class List
    private

    def initialize(options)
      @files = [] # List to display
      # Options
      @options = options
      @max_size = @options[:lines]
    end

    # Return True if list is not full or if :entry is more recent than the
    #   least recent stored candidate
    def check(entry)
      return true if @files.length < @max_size

      LM.lmdate(entry) > LM.lmdate(@files[0])
    end

    # Sort files by ascending LM date, and remove the excess
    def sort
      @files.sort_by! { |f| LM.lmdate(f) }
      @files = @files.pop @files.length - 1 while @files.length > @max_size
    end

    public

    attr_accessor :files

    # Potentially add a file to the list if eligible
    def add(entry)
      return unless check entry

      @files << entry if @files.length < @max_size || LM.lmdate(entry) > LM.lmdate(@files[0])
      sort
    end

    def show
      @files.reverse.each do |f|
        line = f.to_s
        printf "#{line}\n" # last
      end
    end

    def size
      @files.length
    end
  end
end
