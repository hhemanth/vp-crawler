require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'uri'

BASE_NPTEL_URL = "http://nptel.iitm.ac.in/"
LIST_URL = "#{BASE_NPTEL_URL}"

DATA_DIR = "nptel-courses"
Dir.mkdir(DATA_DIR) unless File.exists?(DATA_DIR)

HEADERS_HASH = {"User-Agent" => "Ruby/#{RUBY_VERSION}"}


page = Nokogiri::HTML(open(LIST_URL))
rows = page.css('div table tr')
course_urls = Array.new

rows.each do |row|
#puts "Examining Each row"
  hrefs = row.css("td a").map{ |a| 
  	#puts a['href']
   if a['href'] =~ /disciplineId/
  	  course_urls.push(a['href'])
   end
    #a['href'] if a['href'] =~ /^\/php\// 
  }.compact.uniq
  #puts "hrefs" + hrefs.to_s
end # done: rows.each
#=================
# Gather all NPTEL courses in a db
#1. Use post request to fetch each discipline's courses 
#2. Store the Page.
#3 Open each page, parse the table and store it in CSV or a database

# 1. Display the courses in a page. 
# Code in atleast 3 views. 

#================
#View 1 - connsolidated view - 

POST_URL = "http://nptel.iitm.ac.in/showCourses.php"

course_urls.each do |course_url|

  puts course_url
  discipline_id = course_url.split("=").last
  puts "Fetching courses for disclipline #{discipline_id}..."
  course_list = Net::HTTP.post_form(URI.parse(POST_URL), 
                               {'disciplineId'=>discipline_id})
  puts course_list.title

  local_fname = "#{DATA_DIR}/#{discipline_id}.html"
  #File.open(local_fname, 'w'){|file| file.write(course_list.body)}
  puts "\t...Success, saved to #{local_fname}"
  sleep 1.0 + rand
end

=begin
puts "================================"
course_urls.each do |href|
    remote_url = BASE_NPTEL_URL + href
    local_fname = "#{DATA_DIR}/#{File.basename(href)}.html"
    unless File.exists?(local_fname)
      puts "Fetching #{remote_url}..."
      begin
        course_content = open(remote_url, HEADERS_HASH).read
      rescue Exception=>e
        puts "Error: #{e}"
        sleep 5
      else
        File.open(local_fname, 'w'){|file| file.write(course_content)}
        puts "\t...Success, saved to #{local_fname}"
      ensure
        sleep 1.0 + rand
      end  # done: begin/rescue
    end # done: unless File.exists?
  end # done: hrefs.each
=end



