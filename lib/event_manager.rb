# frozen_string_literal: true

require 'csv'
require 'google/apis/civicinfo_v2'

def clean_zipcode(zip)
  zip.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyAgcTcdrxeK_jjRL_K65d-OVCPBUM8QxDU'

  begin
    legislators = civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: %w[legislatorUpperBody legislatorLowerBody]
    )
    legislators = legislators.officials

    legislator_names = legislators.map(&:name)

    legislators_string = legislator_names.join(", ")
  rescue StandardError
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

puts 'EventManager Initialised.'

template_letter = File.read('form_letter.html')

contents = CSV.open('event_attendees.csv',
                    headers: true,
                    header_converters: :symbol)
contents.each do |row|
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  legislator = legislators_by_zipcode(zipcode)

  personal_letter = template_letter.gsub('FIRST_NAME', name)
  personal_letter.gsub!('LEGISLATORS', legislator)

  puts personal_letter
end
