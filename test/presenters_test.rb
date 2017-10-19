require 'test/unit'
require './app/typekit_objects'
require './app/presenters'

include Presenters

class TestPresenters < Test::Unit::TestCase
  def test_kit_to_console
    # Make a Kit to present.
    kit = Kit.new({"id" => "abc5def", "name" => "Valid Kit", 
                   "domains" => ["valid.domain.com"], "families" => [], 
                   "analytics" => false, "optimize_performance" => false})

    expected_output = "id: abc5def\nname: Valid Kit\ndomains: " \
                      "[\"valid.domain.com\"]\n" \
                      "families:\noptimize_performance: false\n"

    io = StringIO.new
    $stdout = io

    kit_to_console(kit)

    assert_equal io.string, expected_output
  end

  def test_font_family_to_console
    # Make a FontFamily to present.
    family = FontFamily.new({"id" => "abc5def", "name" => "Valid Family Name", 
                             "slug" => "valid_name", 
                             "css_names" => ["Valid CSS Name!"], 
                             "css_stack" => "valid stack", 
                             "subset" => "default", "variations" => ["n1", "n2"]})

    expected_output = "id: abc5def\nname: Valid Family Name\nslug: valid_name\n" \
                      "css_names: [\"Valid CSS Name!\"]\ncss_stack: valid stack\n" \
                      "subset: default\nvariations: [\"n1\", \"n2\"]\n"

    io = StringIO.new
    $stdout = io

    font_family_to_console(family)

    assert_equal io.string, expected_output
  end
  
end