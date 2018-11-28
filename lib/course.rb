class Course

  attr_accessor :name, :url, :lectures, :course_id, :sections

  def initialize(args = {})
    @url  = args.fetch(:url)
    @name = args.fetch(:name)
    @name = get_course_name
    @sections = []
  end

  def add_lectures(lectures)
    self.lectures = lectures
  end

  def add_section(section)
    self.sections << section
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
    Utilities.escape_chars(name.gsub("Enrolled", "").strip.split("\n").first)
  end

end