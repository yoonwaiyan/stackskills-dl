class Course

  attr_accessor :name, :url, :lectures

  def initialize(args = {})
    @url  = args.fetch(:url)
    @name = get_course_name
  end

  def add_lectures(lectures)
    self.lectures = lectures
  end

  def download
    puts "Downloading Course: #{name}"
    Utilities.mkchdir(name) do
      lectures.each do |lecture|
        lecture.download
      end
    end
  end

  private
  def get_course_name
    Utilities.escape_chars(url.strip.split("\n").first)
  end

end