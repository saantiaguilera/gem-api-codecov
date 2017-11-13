#!/usr/bin/env ruby

require 'global-codecov'

Codecov.set_script_destination 'codecov_script.sh'

params = { 't' => ENV['CODECOV_TOKEN'] }
Codecov.run params