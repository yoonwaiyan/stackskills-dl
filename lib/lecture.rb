class Lecture

  attr_accessor :name, :video_url, :video_type, :pdf, :zipf, :index

  def initialize(args = {})
    @name  = args.fetch(:name)
    @index = args.fetch(:index) + 1

    sanitize_lecture_name
  end

  def add_wistia_video(video_id)
    self.video_url  = "https://fast.wistia.net/embed/iframe/#{video_id}"
    self.video_type = :wistia
  end

  def add_video_attachment(video_url)
    self.video_url  = video_url
    self.video_type = :attachment
  end

  def add_pdf(pdf_url)
    self.pdf = pdf_url
  end

  def add_zip(zip_url)
    self.zipf = zip_url
  end

  def download
    puts "Downloading #{name}"
    Utilities.mkchdir("%02d" % index + ". #{name}") do
      download_video
      download_pdf
      download_zip
    end
  end

  private
  def sanitize_lecture_name
    self.name = Utilities.escape_chars(name.split(' | StackSkills').first)
  end

  def download_video
    case video_type
    when :attachment
      puts `wget #{video_url} -c -O #{name}.mp4`
    when :wistia
      puts `youtube-dl --restrict-filenames #{video_url}`
    else
      puts "Sorry, this lecture is not available to download"
    end
  end

  def download_pdf
    return nil unless pdf
    `wget #{pdf.href} -c -O #{pdf.text.split(' ').first}`
  end

  def download_zip
    return nil unless zipf
    `wget #{zipf.href} -c -O #{zipf.text.split(' ').first}`
  end
end
