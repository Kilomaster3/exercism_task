class Grep
  CASE_INSENSITIVE_FLAG = '-i'.freeze
  INVERT_FLAG = '-v'.freeze
  LINE_NUMBERS_FLAG = '-n'.freeze
  ONLY_MATCH_FLAG = '-x'.freeze
  MATCHING_LINE_FLAG = '-l'.freeze
  NEW_LINE = "\n".freeze

  attr_accessor :files, :flags, :pattern

  def initialize(pattern, flags, files)
    @pattern = pattern
    @flags = flags
    @files = files
  end

  def self.grep(*args, &block)
    new(*args).call(&block)
  end

  def call
    create_pattern
    combine_files
      .map { |flag_name, lines| check_flags(flag_name, lines) }
      .compact
      .join(NEW_LINE).strip
  end

  private

  def combine_files
    files.each_with_object({}) { |flag_name, lines| lines[flag_name] = get_lines(flag_name) }
  end

  def get_lines(flag_name)
    file = File.open(flag_name)
    file.readlines.map(&:chomp)
  end

  def check_flags(file, lines)
    return l_flag(file, lines) if @flags.include?(MATCHING_LINE_FLAG)

    lines.each_with_index.map do |line, index|
      "#{multi_files?(file)}#{need_index?(index)}#{line}" if v_flag(line)
    end.compact.join(NEW_LINE)
  end

  def create_pattern
    i = flags.include?(CASE_INSENSITIVE_FLAG) ? Regexp::IGNORECASE : false
    x = flags.include?(ONLY_MATCH_FLAG) ? "^#{pattern}$" : pattern
    @pattern = Regexp.new(x, i)
  end

  def need_index?(index)
    flags.include?(LINE_NUMBERS_FLAG) ? "#{index + 1}:" : ''
  end

  def multi_files?(file)
    files.size > 1 ? "#{file}:" : ''
  end

  def v_flag(string)
    @flags.include?(INVERT_FLAG) ? !string.match(pattern) : string.match(pattern)
  end

  def l_flag(file, lines)
    lines.any? { |line| v_flag(line) } ? file : nil
  end
end
