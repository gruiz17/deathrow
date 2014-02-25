require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'

base_url = "http://www.tdcj.state.tx.us/death_row"
table_url = "#{base_url}/dr_executed_offenders.html"

table_page = Nokogiri::HTML(open(table_url))

rows = table_page.css("table[summary='This table provides a summary of executed offenders with links to their last statements.'] tr")

my_csv = CSV.open("deathrow.csv", "w")
statements = File.new("statements.txt", "w")

csv_header = []
rows[0].css('th').each do |header|
  if header.text != "Link"
    csv_header << header.text.downcase
  end
end
my_csv << csv_header

rows[1..(rows.length-1)].each do |row|
  csv_row = []
  statement_index = 0
  row.css('td').each do |el|
    if (!el.css('a').empty? && el.text.include?('Last'))
      statement_url = base_url + "/" + el.css('a')[0]['href']
      statement_page = Nokogiri::HTML(open(statement_url))
      statement_page.css('div#body p').each do |p|
        if p.text.include?('Statement:')
          statement_index = statement_page.css('div#body p').index(p)
        end
      end
      statement = statement_page.css('div#body p')[statement_index+1..-1].text
      statements << statement + "\n"
    end
    if (el.css('a').empty?)
      csv_row << el.text.strip
    end
  end
  my_csv << csv_row
end

statements.close
