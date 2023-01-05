# frozen_string_literal: true

lines = File.readlines('event_attendees.csv')
lines.each do |line|
  columns = line.split(',')
  name = columns[2]
  p name
end
