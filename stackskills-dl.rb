require 'optparse'
require 'mechanize'
require "highline/import"

def escape_chars(str)
  str.gsub("(", "-").gsub(")", "-").gsub(" ", "_")
end

def download_videos
  
end

input = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ruby stackskills.rb [options]"

  opts.on('-u', '--email NAME', 'Login Email') { |v| input[:email] = v }
  opts.on('-p', '--password PASSWORD', 'Login Password') { |v| input[:password] = v }
  opts.on('-c', '--course COURSE_URL', 'Course URL. Download all courses by default.') { |v| input[:course] = v }

end.parse!

input[:email] ||= ask("Login Email: ")
input[:password] ||= ask("Enter your password:  ") { |q| q.echo = "*" }

a = Mechanize.new.get("https://stackskills.com/sign_in")
form = a.forms.first
form['user[email]'] = input[:email]
form['user[password]'] = input[:password]
page = form.submit
user_dashboard = page.link_with(:href => /courses\/enrolled/)
if user_dashboard
  dashboard_page = user_dashboard.click
  courses = dashboard_page.links_with(href: /courses\/(?!enrolled)/)
  if courses.count > 0
    if input[:course]
      puts "Evaluating the course"
      course_href = input[:course].split("/courses/").last
      course_link = dashboard_page.link_with(href: Regexp.new("#{course_href}"))
      if course_link
        folder_name = escape_chars(course_link.text.strip.split("\n").first)
        puts "Downloading only one course: #{folder_name}"
        Dir.mkdir("#{folder_name}")
        Dir.chdir("#{folder_name}") do
          lectures = course_link.click
          lectures.links_with(href: /lectures/).each_with_index do |lecture, index|
            page = lecture.click
            title = page.title

            lecture_name = escape_chars(title.split(" | StackSkills").first) 
            Dir.mkdir("#{index + 1}. #{lecture_name}")
            Dir.chdir("#{index + 1}. #{lecture_name}") do
              p "Downloading #{lecture_name}"
              video = page.link_with(href: /.mp4/)
              if video
                video_link = video.href
                %x(wget #{video_link} -c -O #{lecture_name}.mp4 )
              end
              pdf = page.link_with(href: /.pdf/)
              if pdf
                %x(wget #{pdf.href} -c -O #{pdf.text.split(" ").first} )
              end
            end
          end
        end
      else
        puts "Couldn't find this course: #{input[:course]}"
      end
    else
      courses.each do |course_link|
        folder_name = escape_chars(course_link.text.strip.split("\n").first)
        Dir.mkdir("#{folder_name}")
        Dir.chdir("#{folder_name}") do
          lectures = course_link.click
          lectures.links_with(href: /lectures/).each_with_index do |lecture, index|
            page = lecture.click
            title = page.title

            lecture_name = escape_chars(title.split(" | StackSkills").first) 
            Dir.mkdir("#{index + 1}. #{lecture_name}")
            Dir.chdir("#{index + 1}. #{lecture_name}") do
              p "Downloading #{lecture_name}"
              video = page.link_with(href: /.mp4/)
              if video
                video_link = video.href
                %x(wget #{video_link} -c -O #{lecture_name}.mp4 )
              end
              pdf = page.link_with(href: /.pdf/)
              if pdf
                %x(wget #{pdf.href} -c -O #{pdf.text.split(" ").first} )
              end
            end
          end
        end
      end
    end
  else
    puts "No course available to download."
  end
else
  puts "Invalid Login Credentials. Please run this program with correct login details."
end
