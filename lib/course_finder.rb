require 'mechanize'
require 'pry'

class CourseFinder

  STACKSKILLS_LOGIN_URL = "https://stackskills.com/sign_in"

  def self.run(input)
    finder = self.new(input)

    Utilities.mkchdir("downloads") do
      finder.execute do |course|
        course.download
      end
    end
    
  end

  attr_accessor :input, :current_page, :courses

  def initialize(input)
    @input = input
  end

  def execute
    @agent = Mechanize.new
    @agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
    self.current_page = @agent.get(STACKSKILLS_LOGIN_URL)
    user_dashboard = login_user!

    return false if user_dashboard.nil?
    self.current_page = user_dashboard
    courses = get_course_links
    puts "Number of courses found: #{courses.count}"

    courses.each do |course_link|
      course = Course.new(url: course_link.href, name: course_link.text)
      lectures = analyze_course(course_link, course)
      course.add_lectures(lectures)

      yield course
    end
  end

  private

  def login_user!
    form = current_page.forms.first
    form['user[email]']    = input.email
    form['user[password]'] = input.password
    page = form.submit
    enrolled_courses_link = page.link_with(href: %r{courses/enrolled})
    unless enrolled_courses_link.nil?
      puts "Login Successfully."
      user_dashboard = enrolled_courses_link.click
      return user_dashboard
    else
      puts "Invalid Login Credentials."
    end
  end

  def get_course_links
    if input.has_course_input?
      course_url = input.course_url
      unless input.course_url_is_id?
        course_url = get_course_link_from_slug(input.course_url)
      end
      courses = [find_course(course_url)].compact
    else
      all_courses
    end
  end

  def get_course_link_from_slug(url)
    course_page = Mechanize.new.get(url)
    form = course_page.forms.first
    course_id = form["course_id"]
    "https://stackskills.com/courses/enrolled/#{course_id}"
  end

  def find_course(course_name)
    puts "Finding #{course_name} from your list of courses"
    course_href = course_name.split('/courses/').last
    course = all_courses.select { |course| course.href =~ Regexp.new(course_href.to_s) }.first

    if course.nil?
      puts "Unable to find this course: #{course_name} from your list of courses."
    end

    course
  end

  def all_courses
    @courses ||= navigate_pages(current_page).flatten.compact
  end

  def navigate_pages(current_page, courses = [])
    links = current_page.links_with(href: %r{courses/enrolled/})
    courses << links

    next_page_link = current_page.link_with(text: /Next/, href: %r{courses/enrolled\?page=})
    unless next_page_link.nil?
      next_page = next_page_link.click
      navigate_pages(next_page, courses)
    else
      return courses.flatten
    end
  end

  def analyze_course(course_link, course)
    processed_lectures = []
    lectures = course_link.click

    lectures.search(".course-section").each_with_index do |section, section_index|
      section_title = section.search(".section-title").children[2].text

      course_section = CourseSection.new(name: section_title, index: section_index)

      section.search(".section-item").each do |lecture|
        href = lecture.children[1]
        lecture_page = @agent.click(href)

        lecture = analyze_lecture(lecture_page, processed_lectures.count)
        lecture.add_section(course_section)

        processed_lectures << lecture
      end
    end

    processed_lectures
  end

  def analyze_lecture(lecture_page, index)
    lecture = Lecture.new(name: lecture_page.title, index: index)
    
    video = lecture_page.link_with(href: /.mp4/)
    if video
      lecture.add_video_attachment(video.href)
    else
      wistia_div = lecture_page.search('div.attachment-wistia-player')
      if wistia_div && wistia_div.count == 1
        video_id = wistia_div.first.attributes["data-wistia-id"].value
        lecture.add_wistia_video(video_id)
      end
    end

    pdf = lecture_page.link_with(href: /.pdf/)
    lecture.add_pdf(pdf) if pdf

    zipf = lecture_page.link_with(href: /.zip/)
    lecture.add_zip(zipf) if zipf

    lecture
  end

end
