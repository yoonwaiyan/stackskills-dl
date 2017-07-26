class CourseSection

  attr_accessor :name, :index

  def initialize(args = {})
    @name  = args.fetch(:name)
    @index = args.fetch(:index)

    sanitize_section_name!
  end

  def directory_name
    "%02d" % index + ". #{name}"
  end

  private
  def sanitize_section_name!
    @name = Utilities.escape_chars(@name.strip)
  end
end