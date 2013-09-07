
require 'rubygems'
require 'nokogiri'
require 'csv'


DATA_DIR = "nptel-courses1"
discipline_ids = [101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,125]

course_list = Array.new
i = 0

discipline_ids.each do |discipline_id|
local_fname = "#{DATA_DIR}/#{discipline_id}.html"

page = Nokogiri::HTML(open(local_fname))   
#puts page.class   # => Nokogiri::HTML::Document

rows = page.css('table.tablesorter tr')
  rows[1..rows.size].each do |row|
  course_list[i] = Hash.new
   course_list[i]['discipline_id'] = discipline_id
   cols = row.css('td')
   course_list[i]['name'] = cols[0].text
   course_list[i]['type'] = cols[1].text
   course_list[i]['author'] = cols[2].text
   course_list[i]['institute'] = cols[3].text
 
   # Begin - Handle  Under Development Courses
   if cols[4].text =~ /development/i
    course_list[i]['under_development'] = true
    #puts "Course under development"
    i = i+1
    next 
   else
    course_list[i]['under_development'] = false
   end
  # End - Handle  Under Development Courses
   links_arr = cols[4].css('a')

   #Begin -  Handle "Syllabus Only" 
   if cols[4].text.to_s =~ /Syllabus only/i
    syllabus_link = links_arr[0]['href']
    course_list[i]['syllabus_link'] = syllabus_link
    course_list[i]['course_id'] = syllabus_link.split("=").last 
    #puts "Has Syllabus Only"
    #puts course_list[i]['course_id'] 
    #puts "============"
    i = i+1
    next
   end
   #End -  Handle Syllabus Only courses

   #Begin -  Handle "Course Contents" 
   if cols[4].text.to_s == "Course contents"  
    course_link = links_arr[0]['href']
    course_list[i]['course_link'] = course_link
    #puts "only course contents"
   end

   if cols[4].text.to_s =~ /syllabus Course contents/i
    course_link = links_arr[1]['href']
    course_list[i]['course_link'] = course_link
    #puts "Has course contents"
   end

   if course_link == nil
    i = i+1
    next
  end

   # find course id from course_link
   if course_link =~ /subjectId/
    course_id = course_link.split("=").last
  else
    course_id = course_link.split("/").last
  end 

  course_list[i]['course_id'] = course_id
  #puts course_id.to_s
   #syllabus_link
   #if !links_arr.
   #puts links_arr["href"]
 
   #links_arr.each do |link_field|
     #puts "**************" + link_field['href'].to_s
     #puts "********" + course_url.size.to_s + "**********"
   #end 

  #cols.each do |col|
   #	 print col.text.to_s + ","
 # end
  
 i = i+1 
end
end

#puts course_list.to_s
video_courses = 0
web_courses = 0
under_dev = 0
total_courses = 0
#print header
print "name,course_id,disciplineId,type,under_development,syllabus_link,course_link"
puts ""
course_list.each do |course|
	print course['name'].to_s.gsub(",", " ") + "," + course['course_id'].to_s + "," + course['discipline_id'].to_s +
	   "," + course['type'].to_s + "," + course['under_development'].to_s + 
	   "," + course['syllabus_link'].to_s + "," + course['course_link'].to_s 

	puts ""
  total_courses +=  1
  if course['under_development'] == true
    under_dev += 1
    next
  end
	if course['type'] =~ /video/i
		video_courses += 1
	end
	if course['type'] =~ /web/i
		web_courses += 1
	end
	
end
# Write the hash into a CSV file

=begin 
puts "total courses" + total_courses.to_s
puts "video courses " + video_courses.to_s
puts "web courses " + web_courses.to_s
puts "Under development " + under_dev.to_s
=end



