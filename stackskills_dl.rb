require 'optparse'
require 'mechanize'
require 'highline/import'
require 'pry'

def escape_chars(str)
  str.tr('(', '-').tr(')', '-').tr(' ', '_')
end

def mkchdir(dir)
  system 'mkdir', '-p', dir
  Dir.chdir(dir) do
    yield
  end
end

def download_video(page, lecture_name)
  video = page.link_with(href: /.mp4/)
  `wget #{video.href} -c -O #{lecture_name}.mp4` if video
end

def download_pdf(page)
  pdf = page.link_with(href: /.pdf/)
  `wget #{pdf.href} -c -O #{pdf.text.split(' ').first}` if pdf
end

def download_lecture(lecture, index)
  page = lecture.click
  lecture_name = escape_chars(page.title.split(' | StackSkills').first)
  mkchdir("#{index + 1}. #{lecture_name}") do
    p "Downloading #{lecture_name}"
    download_video(page, lecture_name)
    download_pdf(page)
  end
end

def download_videos(course_link)
  folder_name = escape_chars(course_link.text.strip.split("\n").first)
  mkchdir(folder_name.to_s) do
    lectures = course_link.click
    lectures.links_with(href: /lectures/).each_with_index do |lecture, index|
      download_lecture(lecture, index)
    end
  end
end

def find_course(course_name, dashboard_page)
  puts "Finding #{course_name} from your list of courses"
  course_href = course_name.split('/courses/').last
  dashboard_page.link_with(href: Regexp.new(course_href.to_s))
end

input = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: ruby stackskills_dl.rb [options]'
  opts.on('-u', '--email NAME', 'Email') { |v| input[:email] = v }
  opts.on('-p', '--password PASSWORD', 'Password') { |v| input[:password] = v }
  opts.on('-c', '--course COURSE_URL', 'Course URL.') { |v| input[:course] = v }
end.parse!

input[:email] ||= ask('Login Email: ')
input[:password] ||= ask('Login password:  ') { |q| q.echo = '*' }

a = Mechanize.new.get('https://stackskills.com/sign_in')
form = a.forms.first
form['user[email]'] = input[:email]
form['user[password]'] = input[:password]
page = form.submit
puts 'Login Successfully'
user_dashboard = page.link_with(href: %r{courses/enrolled})
dashboard_page = user_dashboard.click
if user_dashboard
  courses = dashboard_page.links_with(href: %r{courses/(?!enrolled)})
  puts 'No course available to download.' if courses.count <= 0
  if input[:course]
    course_link = find_course(input[:course])
    if course_link
      puts "Downloading only one course: #{folder_name}"
      download_videos(course_link)
    else
      puts "Couldn't find this course: #{input[:course]}"
    end
  else
    puts 'Downloading all courses'
    courses.each do |link|
      download_videos(link)
    end
  end
else
  puts 'Invalid Login Credentials.'
end
