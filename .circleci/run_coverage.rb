#!/usr/bin/env ruby

require 'codecov'

params = { 't' => ENV['CODECOV_TOKEN'] }
Codecov.run params