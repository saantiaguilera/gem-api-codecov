#!/usr/bin/env ruby

require 'codecov'

Codecov.set_script_destination 'codecov_script.sh'

params = { 't' => ENV['CODECOV_TOKEN'] }
Codecov.run params