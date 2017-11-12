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

	##
	# Codecov absolute file destionation
	##
	CODECOV_DESTINATION = "~/codecov_script.sh"

	##
	# Script endpoint from where to download the codecov file
	##
	SCRIPT_ENDPOINT = 'https://codecov.io/bash'.freeze

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
		CODECOV_DESTINATION = dest.to_s.shellescape
	end

	##
	# PUBLIC
	# 
	# Runs codecov
	#
	# @params map with parameters for codecov
	# Eg.
	# params = { 
	#   'c' => '',
	#   'X' => [ 'gcov', 'coveragepy', 'fix' ],
	#   'R' => 'root_dir',
	#   't' => 'MY_ACCESS_TOKEN'
	# }
	# 
	# Translates to:
	# bash <(http://codecov.io/bash) -c -X gcov -X coveragepy -X fix
	#        -R root_dir -t MY_ACCESS_TOKEN
	#
	# Notes: This will shellescape ALL, since this is still a shell
	# so using $MY_VAR wont work. If you want to pass a variable
	# use ENV['MY_VAR'] and pass that in the map.
	#
	# For information about all the params codecov supports, refer
	# to the bash script -h function :)
	##
	def self.run(params = nil)
		download_script unless File.file? CODECOV_DESTINATION

		flags = params.map { |k,v|
			flag = k.to_s.shellescape unless v
			flag = "-#{k.to_s.shellescape} #{v.to_s.shellescape}" if v.is_a? String
			flag = v.each { |param| "-#{k.to_s.shellescape} #{param.to_s.shellescape}"} if v.is_a? Array

			raise "Cant understand '#{k}' => '#{v}'" if flag.nil?
			return flag
		}.join(' ') unless params.nil?

		system "bash #{CODECOV_DESTINATION} #{flags || ''}"
	end

	##
	# PRIVATE. This method is for the api, avoid using it
	#
	# Downloads the SCRIPT_ENDPOINT into the CODECOV_DESTINATION
	# This method doesnt have behavior if the CODECOV_DESTINATION
	# already exists
	##
	def self.download_script()
		unless File.file? CODECOV_DESTINATION
			download = open(SCRIPT_ENDPOINT)
			IO.copy_stream(download, CODECOV_DESTINATION)
		end
	end

end
