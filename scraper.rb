require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'

base_url = "http://www.tdcj.state.tx.us/death_row"
table_url = "#{base_url}/dr_executed_offenders.html"

other_info_urls = "#{base_url}/dr_info/"

table_page = Nokogiri::HTML(open(table_url))

rows = table_page.css("table[summary='This table provides a summary of executed offenders with links to their last statements.'] tr")

my_csv = CSV.open("deathrow.csv", "w")

csv_header = []
rows[0].css('th').each do |header|
  if header.text != "Link"
    csv_header << header.text
  end
end
my_csv << csv_header

rows[1..(rows.length-1)].each do |row|
  csv_row = []
  row.css('td').each do |el|
    if (el.css('a').empty?)
      csv_row << el.text
    end
  end
  my_csv << csv_row
end
