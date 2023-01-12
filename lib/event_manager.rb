# frozen_string_literal: true

require 'csv'

def clean_zipcode(zip)
  if zip.nil?
    zip = '00000'
  elsif zip.length < 5
    zip = zip.rjust(5, '0')
  elsif zip.length > 5
    zip = zip[0..4]
  end
  zip
end

puts 'EventManager Initialised.'

contents = CSV.open('event_attendees.csv',
                    headers: true,
                    header_converters: :symbol)
contents.each do |row|
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])

  puts "#{name} #{zipcode}"
end
