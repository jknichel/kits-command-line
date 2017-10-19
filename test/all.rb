# Run all tests in this directory by running "ruby test/all.rb" from the base directory

Dir[File.dirname(File.absolute_path(__FILE__)) + '/**/*.rb'].each {|file| require file }
