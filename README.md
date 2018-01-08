# stackskills-dl

## Information

Being inspired by some popular downloader libraries(youtube-dl, udemy-dl etc.) and no downloader library available for StackSkills(or SkillWise) courses, I've decided to put on this small scraping library to help you download the courses to your machine for offline viewing and take it as part of my Ruby learning and contributing to open source community.

This library will by default get all your subscribed courses and download them all into your local filesystem, structured into folders of course sections in each course and folders of lectures of each course section. The courses will be available in your `/downloads` folder within this repo.

:exclamation:This is a **non-official** Ruby script to download all StackSkills tutorials. Login details is required to get your subscribed courses to be downloaded.:exclamation:

## Usage

#### Pre-requisites (Important!!)

1. wget (installing guide for macOS system in [Stack Overflow](https://stackoverflow.com/questions/33886917/how-to-install-wget-in-macos-capitan-sierra)) to download file attachments(videos, PDFs and zipped files).
2. [youtube-dl](https://github.com/rg3/youtube-dl) for Wistia videos.

#### For Non-Ruby Downloaders

If this is the first time you're running a Ruby script, it is recommended to install Ruby via a version manager i.e. rvm or rbenv, but installing Ruby directly is fine for a short term usage to make sure the script is compatible with the current Ruby version.

#### For Windows Users

The script may not be working well with Windows systems based on some issues being reported. If you're familiar with command prompt/Linux based commands and have Git installed, please try to use Git bash to run the script.

If you're facing problems related to wget, do make sure wget can be run within your working directory i.e. directory that runs this script.

This script requires Mechanize gem to run.

```ruby
bundle install
```

To use this script:

```ruby
ruby stackskills_dl.rb
```

The script will prompt your login details and download all courses available in your "Enrolled Courses" page. Alternatively, you can save your credentials to environment variables as `STACKSKILLS_EMAIL` and `STACKSKILLS_PASSWORD` for login email and password respectively.

Flags are available to pass login details and optional course link to the script.
To see what are the available options, please type:

```ruby
ruby stackskills_dl.rb --help
```

For example, if you want to download only one course:

**Using course ID:**

```ruby
ruby stackskills_dl.rb -c https://stackskills.com/courses/enrolled/68582
```

**Using course slug:**

```ruby
ruby stackskills_dl.rb -s https://stackskills.com/courses/beginning-rails-programming
```

## Change Log

Change log is available in CHANGELOG.md.
