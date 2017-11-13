#!/usr/bin/env ruby

require 'codecov'

Codecov.run { 't' => ENV['CODECOV_TOKEN'] }