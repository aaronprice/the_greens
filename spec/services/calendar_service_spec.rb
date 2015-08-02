require "rails_helper"

RSpec.describe CalendarService do

  let(:date) { Date.parse("2014-04-16") }

  it "reservation_intervals" do
    expect(CalendarService.new(date).reservation_intervals.count).to eq(24)
  end

  it "next_week" do
    expect(CalendarService.new(date).next_week).to eq(Date.parse("2014-04-23"))
  end

  it "previous_week" do
    expect(CalendarService.new(date).previous_week).to eq(Date.parse("2014-04-09"))
  end

  it "previous_week_from" do
    expect(CalendarService.new(date).previous_week_from).to eq(Date.parse("2014-04-07"))
  end

  it "previous_week_to" do
    expect(CalendarService.new(date).previous_week_to).to eq(Date.parse("2014-04-13"))
  end

  it "next_week_from" do
    expect(CalendarService.new(date).next_week_from).to eq(Date.parse("2014-04-21"))
  end

  it "next_week_to" do
    expect(CalendarService.new(date).next_week_to).to eq(Date.parse("2014-04-27"))
  end
end