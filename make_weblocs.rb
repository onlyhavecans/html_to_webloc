#!/usr/bin/env ruby
# frozen_string_literal: true

require 'erb'
require 'nokogiri'
require 'open-uri'

OUTPUT_DIR = 'output'
POCKET_EXPORT_FILE = 'ril_export.html'
WEBLOC_TEMPLATE = <<~TEMPLATE
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
  <dict>
    <key>URL</key>
    <string><%= url %></string>
  </dict>
  </plist>
TEMPLATE

def get_a_records_from_file(filename)
  exported_html = Nokogiri::HTML.parse(open(filename))
  exported_html.xpath('//a')
end

def get_title_from_url(url)
  article = Nokogiri::HTML.parse(open(url))
  article.title
end

def page_title_to_filename(title)
  # Clean all problimatic path characters
  cleaned_title = title.delete('<>"\'|*:?./\\').strip
  # Remove extra spaces from delete
  cleaned_title.gsub!('  ', ' ')
  # Add extension
  "#{cleaned_title}.webloc"
end

def write_file(filepath, contents)
  File.open(filepath, 'w') { |f| f.write contents }
end

## Main
a_records = get_a_records_from_file(POCKET_EXPORT_FILE)

a_records.each do |a|
  url = a[:href]
  title = a.text

  begin
    title = get_title_from_url(title) if title.start_with?('http')
  rescue OpenURI::HTTPError => e
    puts '!! While looking up the tile of URL we received an HTTP Error!'
    puts "!  URL in question: #{title}"
    puts "!  Error Received: #{e.message}"
    next
  end

  filename = page_title_to_filename(title)
  filepath = File.join(OUTPUT_DIR, filename)

  template = ERB.new(WEBLOC_TEMPLATE)
  output = template.result(binding)

  if File.file?(filepath)
    puts "! This already exists so we skip: #{filepath}"
  else
    puts "Writing #{filepath}"
    write_file(filepath, output)
  end
end
