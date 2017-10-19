# Module for miscellanious helper functions.
module Helpers
  # Checks if the response contains an error and takes over the reins if it does.
  def check_and_handle_error_response(response)
    unless response['error'].nil?
      puts "The response contained an error. Message: #{response['error']}"
      exit
    end
  end

  # Prompts the user for an ID. It takes in the type of object whose ID you're 
  # requesting, and what action will be performed on that object once found.
  def prompt_obj_id(obj_type, action)
    print "Enter #{obj_type} ID to #{action}: "
    id = gets.chomp
    while id.empty?
      print "Please enter an ID: "
      id = gets.chomp
    end
    id.delete(' ')
  end
end
