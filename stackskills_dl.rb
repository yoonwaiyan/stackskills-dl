require './lib/input'
require './lib/course_finder'
require './lib/course'
require './lib/course_section'
require './lib/lecture'
require './lib/utilities'

input = Input.get_input
CourseFinder.run(input)
