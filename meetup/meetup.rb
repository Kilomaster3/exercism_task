require 'date'

class Meetup
  attr_reader :month
  POSITION = { first: 0, second: 1, third: 2, fourth: 3, last: -1 }.freeze

  def initialize(month, year)
    @month =  Date.new(year, month, 1).step(Date.new(year, month, -1))
  end

  def day(day, r_day)
    r_day == :teenth ? monteenth(day) : candidates(day)[POSITION[r_day]]
  end

  def candidates(day)
    month.to_a.select { |d| d.send("#{day}?") }
  end

  def monteenth(day)
    candidates(day).select { |d| d.day < 20 && d.day > 12 }.first
  end
end
