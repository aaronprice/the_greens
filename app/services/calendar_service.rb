class CalendarService

  attr_accessor :date

  def initialize(date)
    self.date = date
  end

  def reservation_intervals
    time_slots = []

    (9..16).each do |hour|
      time_slots << Time.new(self.date.year, self.date.month, self.date.day, hour, 0, 0)
      time_slots << Time.new(self.date.year, self.date.month, self.date.day, hour, 20, 0)
      time_slots << Time.new(self.date.year, self.date.month, self.date.day, hour, 40, 0)
    end

    time_slots
  end

  def next_week
    date + 1.week
  end

  def previous_week
    date - 1.week
  end

  def next_week_from
    next_week.at_beginning_of_week
  end

  def next_week_to
    next_week.at_end_of_week
  end

  def previous_week_from
    previous_week.at_beginning_of_week
  end

  def previous_week_to
    previous_week.at_end_of_week
  end
end