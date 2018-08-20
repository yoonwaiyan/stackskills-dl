require 'optparse'
require 'highline/import'

class Input
  attr_accessor :email, :password, :course_url, :course_url_type

  def self.get_input
    self.new
  end

  def initialize(args = {})
    parse_options
    get_environment_variables
    unless has_complete_login_input?
      prompt_login_credentials
    else
      puts "Loaded login credentials from environment variables."
    end
  end

  def has_course_input?
    !course_url.nil?
  end

  def has_complete_login_input?
     has_email? && has_password?
  end

  def has_email?
    !email.nil? && email.length > 0
  end

  def has_password?
    !password.nil? && password.length > 0
  end

  def course_url_is_id?
    course_url_type == :id
  end

  def get_environment_variables
    self.email    = ENV["STACKSKILLS_EMAIL"]
    self.password = ENV["STACKSKILLS_PASSWORD"]
  end

  private
  def prompt_login_credentials
    self.email    = ask('Login Email: ')
    self.password = ask('Login password: ') { |q| q.echo = '*' }
  end

  def options_structure
    OptionParser.new do |opts|
      opts.banner = 'Usage: ruby stackskills_dl.rb [options]'

      opts.on('-u', '--email NAME', 'Email') do |email|
        self.email = email        
      end

      opts.on('-p', '--password PASSWORD', 'Password') do |password|
        self.password = password
      end
      opts.on('-c', '--course COURSE_URL', 'Course URL in ID.') do |course_url|
        self.course_url = course_url
        self.course_url_type = :id
      end
      opts.on('-s', '--course-slug COURSE_SLUG', 'Course URL in slug.') do |course_url|
        self.course_url = course_url
        self.course_url_type = :slug
      end
    end
  end

  def parse_options
    options_structure.parse!
  end
end