require 'csv'
require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'uri'
require './page'

file_name = "../course_list.txt"
nptel_url = "http://nptel.iitm.ac.in/courses/"

def parse_page(page_url)
    p = Page.new(page_url)
#<div class="breadcrumbs" style="margin-left:5px"><a class="breadcrumbs" href="/">NPTEL</a>  &gt;&gt; Metallurgy and Material Science &gt;&gt; Science and Technology of Polymers&nbsp;(Video) Under Review &gt;&gt; <span id="lecturename">Basic Concepts on Polymers</span></div>
   breadcrumb =  p.get_breadcrumbs()
   if breadcrumb.text =~ /Review/
    puts "*****"
     else
          puts "------------"

      puts page_url
     puts breadcrumb.text

   end
   #css("div#breadcrumbs")
end
CSV.foreach(file_name) do |row|
  course_url = nptel_url + row[0] + "/"
  parse_page(course_url)
end
