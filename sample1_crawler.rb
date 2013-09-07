require 'capybara/dsl'
require 'capybara-webkit'

include Capybara::DSL
Capybara.current_driver = :webkit
Capybara.app_host = 'http://nptel.iitm.ac.in/courses.php?disciplineId=109'
page.visit('/')
puts page.html
