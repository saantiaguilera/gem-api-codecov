#!/usr/bin/env ruby

# THey still dont support running from a bash script. So this cant be done yet

require 'global-codecov'

Codecov.set_script_destination 'codecov_script.sh'

params = { 't' => ENV['CODECOV_TOKEN'] }
Codecov.run params