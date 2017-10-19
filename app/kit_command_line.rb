#!/usr/bin/env ruby

require 'json'
require 'optparse'
require_relative 'helpers'
require_relative 'typekit_objects'
require_relative 'presenters'
require_relative 'typekit_api_interface'
require './lib/tk_auth'

include Helpers
include Presenters

# Constant that holds a list of all methods that are mapped to different API 
# endpoint functionalities.
FUNCTIONS = ['list-kits', 'kit-info', 'update-kit', 'create-kit', 'delete-kit']

# Hash to hold options input from the command line.
options = {}

# Default to showing the help menu if called with no arguments.
ARGV << '-h' if ARGV.empty?

# Parse the options from the command line.
OptionParser.new do |parser|
  parser.banner = 'Usage: kit.rb [options] '

  parser.on('-h', '--help', 'Show this help message and stop execution') do ||
    puts parser
    exit
  end

  # Defaults to the value of KEY constant in tk_auth.rb, for convenience
  options[:tk_auth_key] = TypekitAuthKey::KEY
  parser.on('-a', '--auth-key KEY', String, 'The Typekit API key to use.', 
            'Defaults to the KEY defined in tk_auth.rb') do |key|
    options[:tk_auth_key] = key
  end
  
  parser.on('-f', '--function FUNCTION', FUNCTIONS, 
            "Which function to perform. Options are: ", *FUNCTIONS) do |function|
    options[:function] = function
  end

  parser.on('-i', '--id ID', String, "The ID of the object to be acted on.",
             "You will be prompted to enter an ID", 
             "if you fail to provide an ID for a function that needs one.") do |id|
    options[:id] = id
  end

  options[:params] = ''
  parser.on('-p', '--parameters JSON', String, 
            "Parameters specified in JSON to be used as a payload", 
            "for POST functions, otherwise ignored.") do |json|
    options[:params] = json
  end

end.parse!

# Startup our wrapper class to be used once we decide what endpoint we're accessing.
wrapper = TypekitApiInterface::TypekitApiWrapper.new(options[:tk_auth_key])

# Switch-case for choosing a function. The OptionParser should catch invalid
# function inputs, so an else is unneccesary. For the most part, these follow
# the same format: get extra info if necessary, make a request with that info
# and store the response JSON, use the response to create an object, print the
# object with the appropriate presenter.
begin
  case options[:function]
  when 'list-kits'
    response = wrapper.list_kits
    check_and_handle_error_response(response)
    kit_list_to_console(response)

  when 'kit-info'
    # If the ID wasn't passed, prompt the user for it.
    options[:id] ||= prompt_obj_id('kit', 'get info for')
    response = wrapper.kit_info(options[:id])
    check_and_handle_error_response(response)
    kit = Kit.new(response['kit'])
    kit_to_console(kit)

  when 'update-kit'
    options[:id] ||= prompt_obj_id('kit', 'update')
    response = wrapper.update_kit(options[:id], options[:params])
    check_and_handle_error_response(response)
    kit = Kit.new(response['kit'])
    kit_to_console(kit)

  when 'create-kit'
    response = wrapper.create_kit(options[:params])
    check_and_handle_error_response(response)
    kit = Kit.new(response['kit'])
    kit_to_console(kit)

  when 'delete-kit'
    options[:id] ||= prompt_obj_id('kit', 'delete')
    response = wrapper.delete_kit(options[:id])
    check_and_handle_error_response(response)
    if response['ok']
      puts 'Succesfully deleted!'
    else
      # This shouldn't be reached. A failed deletion should raise prior to this
      # because of an errored response. If we do make it here, warn the user
      # that the deletion has failed but we don't really know why.
      puts 'Deletion failed for unknown reason.'
    end

  end
# Here to catch the an exception caused by the failed parsing of user-input JSON.
rescue JSON::ParserError => e
  puts "Invalid JSON entered for --parameters option. Parsing error message:"
  puts e.message
end
