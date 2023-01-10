# frozen_string_literal: true

require 'csv'
puts 'EventManager Initialised.'

contents = CSV.open('event_attendees.csv',
                    headers: true,
                    header_converters: :symbol)
contents.each do |row|
  name = row[2]
  p name
end
