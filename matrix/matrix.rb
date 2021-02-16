class Matrix
  attr_reader :rows, :columns

  def initialize(matrix)
    @rows = take_string_rows(matrix)
    @columns = rows.transpose
  end

  private

  def take_string_rows(matrix)
    matrix.split(/\n/).map { |rows| rows.split.map(&:to_i) }
  end
end
