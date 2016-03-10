This is a **non-official** Ruby script to download all StackSkills tutorials.

## Usage
This script requires Mechanize gem to run.
```ruby
bundle install
```

To use this script, simply exec this script:
```ruby
ruby stackskills-dl.rb
```
This script will prompt your login details and download all courses available on your "Enrolled Courses" page.

Flags are available to pass login details and optional course link to the script.
To see what are the available options, please type:
```ruby
ruby stackskills-dl.rb --help
```

For example, if you want to download only one course:
```ruby
ruby stackskills-dl.rb -c https://stackskills.com/courses/java-programming-the-master-course
```

## License
MIT License