class CalendarService

  def self.reservation_intervals(day)
    time_slots = []

    (9..16).each do |hour|
      time_slots << Time.new(day.year, day.month, day.day, hour, 0, 0)
      time_slots << Time.new(day.year, day.month, day.day, hour, 20, 0)
      time_slots << Time.new(day.year, day.month, day.day, hour, 40, 0)
    end

    time_slots
  end
end