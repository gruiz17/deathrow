require 'rubygems'
require 'nokogiri'
require 'open-uri'

base_url = "http://www.tdcj.state.tx.us/death_row"
table_url = "#{base_url}/dr_executed_offenders.html"

other_info_urls = "#{base_url}/dr_info/"

table_page = Nokogiri::HTML(open(table_url))


