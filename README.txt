This is a simple command line interface application written in Ruby to wrap
some functionality surrounding Kits from the old Typekit API.

How to use:
The application is a simple command line tool. Usage is either:
                    ./kit.rb [options]
                            or
                   ruby kit.rb [options]

Running the application with no options or the -h (--help) option will provide
a help menu with much of the same information as you'll find here.

Options Index:

-h, --help               - Show this help message and stop execution

--a, --auth-key KEY      - The Typekit API key to use. Defaults to the KEY 
                           defined in lib/tk_auth.rb

--f, --function FUNCTION - Which function to perform. Options are:
                           list-kits
                           kit-info
                           update-kit
                           create-kit
                           delete-kit

-i, --id ID              - The ID of the object to be acted on. You will be 
                           prompted to enter an ID if you fail to provide an ID
                           for a function that needs one.

-p, --parameters JSON    - Parameters specified in JSON to be used as a payload
                           for POST functions, otherwise ignored.

Explanation of Functions:

-list-kits: 
  Print to the console a list of all kits associated with the account that the 
  passed API key belongs to.

-kit-info: 
  Print to the console all information about the kit specified by ID.

-update-kit: 
  Make POST request to update the kit specified by ID with the passed JSON.

-create-kit: 
  Make POST request to create a kit with parameters specified by the passed JSON.

-delete-kit: 
  Make DELETE request to delete the kit specified by ID.

Further explanation of options:

-a:
  Specifies the API authentication key to include in the request header. If
  this option isn't present it defaults to the value defined in lib/tk_auth.rb.

-id: 
  This option specifies the ID of the account to act on. This field is required
  for kit-info, update-kit, and delete-kit. If a function requires an ID and it
  this option isn't present, the application with prompt the user to enter one.

-p:
  Where the payload parameters for POST requests are specified. This input has 
  to be in JSON. Since it's command line input, the string should be enclosed 
  in single quotes and the attributes should be enclosed in double quotes. 
  Example: '{"name": "Example Name"}'
  Head to https://typekit.com/docs/api/v1/:format/kits to see more information
  about how to format the parameters to send.

Running Tests:
  Simply run "ruby test/all.rb" from the base directory of the project.
  