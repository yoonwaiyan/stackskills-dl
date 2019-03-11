class Lecture

  attr_accessor :name, :section, :video_url, :video_type, :pdf, :zipf, :txt, :index

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

  def add_text(text_url)
    self.txt = text_url
  end

  def add_section(section)
    self.section = section
  end

  def download
    puts "Downloading #{name}"
    Utilities.mkchdir("#{section.directory_name}/#{directory_name}") do
      download_video
      download_pdf
      download_zip
      download_text
    end
  end

  private
  def directory_name
    "%02d" % index + ". #{name}"
  end

  def sanitize_lecture_name
    self.name = Utilities.escape_chars(name.split(' | StackSkills').first)
  end

  def download_video
    case video_type
    when :attachment
      system(
        "wget",
        video_url,
        "-c",
        "-O",  "#{name}.mp4",
        "--no-check-certificate"
      )
    when :wistia
      system(
        "youtube-dl",
        "--restrict-filenames",
        video_url
      )
    else
      puts "Sorry, this lecture is not available to download"
    end
  end

  def download_pdf
    return nil unless pdf
    system(
      "wget",
      pdf.href,
      "-c",
      "-O", pdf.text.split(" ").first,
      "--no-check-certificate"
    )
  end

  def download_zip
    return nil unless zipf
    system(
      "wget",
      zipf.href,
      "-c",
      "-O", zipf.text.split(" ").first,
      "--no-check-certificate"
    )
  end

  def download_text
    return nil unless txt
    system(
      "wget",
      txt.href,
      "-c",
      "-O", txt.text.split(" ").first,
      "--no-check-certificate"
    )
  end
end
