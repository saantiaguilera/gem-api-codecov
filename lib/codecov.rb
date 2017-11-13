require 'shellwords'
require 'open-uri'

##
# Codecov module for executing codecov coverage
# for any platform independently
##
module Codecov
  
	##
	# Gem information
	##
	NAME = 'codecov'.freeze
	VERSION = '1.0.0'.freeze

	class << self
		attr_accessor :CODECOV_DESTINATION
		attr_accessor :SCRIPT_ENDPOINT
	end

	##
	# Codecov absolute file destionation
	##
	self.CODECOV_DESTINATION = "~/codecov_script.sh"

	##
	# Script endpoint from where to download the codecov file
	##
	self.SCRIPT_ENDPOINT = 'https://codecov.io/bash'.freeze

	##
	# PUBLIC
	#
	# Set the script destination path. 
	# We will download the bash script in this path
	# 
	# @param dest String with the absolute file path, used as destination
	# for the bash script
	#
	# Defaults to "~/codecov_script.sh"
	##
	def self.set_script_destination(dest)
		self.CODECOV_DESTINATION = dest.to_s.shellescape
	end

	##
	# PUBLIC
	# 
	# Runs codecov
	#
	# @params map with parameters for codecov
	# @returns command ran
	# Eg.
	# params = { 
	#   'c' => nil,
	#   'empty' => '',
	#   'X' => [ 'gcov', 'coveragepy', 'fix' ],
	#   'R' => 'root_dir',
	#   't' => 'MY_ACCESS_TOKEN'
	# }
	# 
	# Translates to:
	# bash <(http://codecov.io/bash) -c -empty '' -X gcov -X coveragepy
	#        -X fix -R root_dir -t MY_ACCESS_TOKEN
	#
	# Notes: This will shellescape ALL, since this is still a shell
	# so using $MY_VAR wont work. If you want to pass a variable
	# use ENV['MY_VAR'] and pass that in the map.
	#
	# For information about all the params codecov supports, refer
	# to the bash script -h function :)
	##
	def self.run(params = nil)
		download_script unless File.file? self.CODECOV_DESTINATION

		flags = ''
		flags << as_flags(params) unless params.nil?

		command = "bash #{self.CODECOV_DESTINATION} #{flags}"

		system command
		return command
	end

	##
	# Transforms the params into flags
	# @param params nonnull map of <k,v>
	##
	def self.as_flags(params)
		return '' if params.nil?

		return params.map { |k,v|
			case
				when v.nil?
					"-#{k.to_s.shellescape}"
				when v.is_a?(String)
					"-#{k.to_s.shellescape} #{v.to_s.shellescape}"
				when v.is_a?(Array)
					v.flat_map { |iv| [ "-#{k.to_s.shellescape}", iv.to_s.shellescape ] }[0..-1].join(' ')
				else 
					raise "Cant understand '#{k}' => '#{v}'"
			end
		}.join(' ')
	end

	##
	# PRIVATE. This method is for the api, avoid using it
	#
	# Downloads the SCRIPT_ENDPOINT into the CODECOV_DESTINATION
	# This method doesnt have behavior if the CODECOV_DESTINATION
	# already exists
	##
	def self.download_script()
		unless File.file? self.CODECOV_DESTINATION
			download = open(self.SCRIPT_ENDPOINT)
			IO.copy_stream(download, self.CODECOV_DESTINATION)
		end
	end

end
