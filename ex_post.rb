require 'net/http'
require 'uri'
 
discipline_id = '103'
postData = Net::HTTP.post_form(URI.parse('http://nptel.iitm.ac.in/showCourses.php'), 
                               {'disciplineId'=>discipline_id})

 # local_fname = "#{DATA_DIR}/#{discipline_id}.html"
  #File.open(local_fname, 'w'){|file| file.write(course_list)}
 # puts "\t...Success, saved to #{local_fname}"

puts postData.body
