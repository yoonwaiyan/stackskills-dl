This is a **non-official** Ruby script to download all StackSkills tutorials. Login details is required to acquire the subscribed courses to be downloaded.

## Usage
**Important!!**
- Please download wget to download attached files(videos, PDFs and zipped files).
- For Wistia videos, please install [youtube-dl](https://github.com/rg3/youtube-dl) to avoid any error.

This script requires Mechanize gem to run.
```ruby
bundle install
```

To use this script:
```ruby
ruby stackskills_dl.rb
```
This script will prompt your login details and download all courses available in your "Enrolled Courses" page.

Flags are available to pass login details and optional course link to the script.
To see what are the available options, please type:
```ruby
ruby stackskills_dl.rb --help
```

For example, if you want to download only one course:
```ruby
ruby stackskills_dl.rb -c https://stackskills.com/courses/java-programming-the-master-course
```