require 'optparse'
require 'highline/import'

class Input
  attr_accessor :email, :password, :course_url

  def self.get_input
    self.new
  end

  def initialize(args = {})
    parse_options
    prompt_login_credentials
  end

  def has_course_input?
    !course_url.nil?
  end

  private
  def prompt_login_credentials
    self.email    ||= ask('Login Email: ')
    self.password ||= ask('Login password: ') { |q| q.echo = '*' }
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
      opts.on('-c', '--course COURSE_URL', 'Course URL.') do |course_url|
        self.course_url = course_url
      end
    end
  end

  def parse_options
    options_structure.parse!
  end
end