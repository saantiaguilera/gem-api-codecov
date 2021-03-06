# Codecov

[![CircleCI](https://circleci.com/gh/saantiaguilera/gem-api-codecov/tree/master.svg?style=svg)](https://circleci.com/gh/saantiaguilera/gem-api-codecov/tree/master) [![codecov](https://codecov.io/gh/saantiaguilera/gem-api-codecov/branch/master/graph/badge.svg)](https://codecov.io/gh/saantiaguilera/gem-api-codecov) [![Gem Version](https://badge.fury.io/rb/global-codecov.svg)](https://badge.fury.io/rb/global-codecov) ![](https://ruby-gem-downloads-badge.herokuapp.com/global-codecov/1.0.0)

This gem is for running codecov for any language (apart from ruby itself, since [their bash script doesnt support it yet](https://github.com/codecov/codecov-ruby/issues/4#issuecomment-121964456)) from a ruby script. 

The point of this nonsense is that a lot of frameworks for continuous integration (eg. fastlane) are written in ruby. This is a tool for running your coverage under those circumstances

If you were using bash, you would do a simple curl redirect into a shell (`bash <(curl -s http://some.bash.script.com)`). But this cant be done from ruby since the redirect isnt available, this gem is here for providing exactly that behavior.

## Installation

Add this line to your application's Gemfile:

    $ gem 'global-codecov'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install global-codecov

## Usage

### Import

Require the module:
```ruby
require 'global-codecov'
```

### Setting destination of the script

Use the provided setter
```ruby
Codecov.set_script_destination "somewhere/over/the/rainbow/file.sh"
```

_Note_: The module will only download the file once, so that the overhead of the api is as low as possible

### Running

For running simply invoke                    
```ruby
Codecov.run
```
And thats it! It will be as running `bash <(https://www.codecov.io/bash)`

#### Arguments

If you wish to pass arguments to the bash script, pass them as a map of either `nil`, `String` or `Array`.

Eg.
```ruby
params = {
  'c' => nil,
  'X' => [ 'glib', 'silent', 'test' ],
  't' => 'access_token',
  'root_dir' => '',
  's' => nil,
  'f' => [ 'file1.txt', 'file2.txt' ]
}
Codecov.run params
```
Will be: `bash <(https://www.codecov.io/bash) -c -X glib -X silent -X test -t access_token -root_dir '' -s -f file1.txt -f file2.txt`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/saantiaguilera/ruby-api-codecov. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [BSD-3 License](https://opensource.org/licenses/BSD-3-Clause).

## Code of Conduct

Everyone interacting in the Codecov project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/saantiaguilera/ruby-api-codecov/blob/master/CODE_OF_CONDUCT.md).
