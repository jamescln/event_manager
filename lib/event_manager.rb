# frozen_string_literal: true

require 'csv'
puts 'EventManager Initialised.'

# lines = File.readlines('event_attendees.csv')
# lines.each_with_index do |line, index|
  # use next to skip an iteration based on an evaluation
  # next if index.zero?

  # split converts a string to an array
  # pass a comma as an argument so that the array
  # is split on that character
  # columns = line.split(',')
  # the data can now be referenced with an index
  # name = columns[2]
  # p name
# end

contents = CSV.open('event_attendees.csv', headers: true)
contents.each do |row|
  name = row[2]
  p name
end