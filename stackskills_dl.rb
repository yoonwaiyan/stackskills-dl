#!/usr/bin/env ruby

require './lib/input'
require './lib/course_finder'
require './lib/course'
require './lib/course_section'
require './lib/lecture'
require './lib/utilities'

input = Input.get_input
CourseFinder.run(input)

trap('INT') do
  puts "Exiting..."
  exit!
end

trap('SIGINT') do
  puts "SIGINT"
  exit!
end

trap('TERM') do
  puts "TERMINAL"
  exit!
end