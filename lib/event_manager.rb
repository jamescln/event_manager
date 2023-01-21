# frozen_string_literal: true

require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

def clean_zipcode(zip)
  zip.to_s.rjust(5, '0')[0..4]
end

def clean_home_phone(home_phone)
  home_phone_string = home_phone.to_s
  unless home_phone_string.length == 10
    if home_phone_string.length == 11 && home_phone_string.start_with?('1')
      home_phone_string[1..10]
    else
      'Invalid number provided'
    end
  end

  home_phone_string
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyAgcTcdrxeK_jjRL_K65d-OVCPBUM8QxDU'

  begin
    civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: %w[legislatorUpperBody legislatorLowerBody]
    ).officials
  rescue StandardError
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

puts 'EventManager Initialised.'

contents = CSV.open('event_attendees.csv',
                    headers: true,
                    header_converters: :symbol)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  phone_number = clean_home_phone(row[:homephone])
  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  save_thank_you_letter(id, form_letter)
end
