class CourseSection

  attr_accessor :name, :lecture_ids
  def initialize(args = {})
    @name = args.fetch(:name)

    sanitize_section_name!
  end

  def add_lecture(lecture_id)
    lecture_ids << lecture_id.to_sym
  end

  private
  def sanitize_section_name!
    @name = @name.strip
  end
end