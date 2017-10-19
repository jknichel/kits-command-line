require 'test/unit'
require './app/typekit_objects'

class TestObjects < Test::Unit::TestCase
  def test_kit
    # Valid params for Kit
    valid_params = {"id" => "abc5def", "name" => "Valid Kit",
                    "domains" => ["valid.domain.com"], "families" => [],
                    "analytics" => false, "optimize_performance" => false}
    # Invalid datatypes in valid attributes.
    invalid_datatype_params = {"id" => false, "name" => 1234, "domains" => {},
                               "families" => "hello, world",
                               "analytics" => "something",
                              "optimize_peformance" => "false"}
    # Invalid attribute name in otherwise valid parameters.
    invalid_attributes_params = {"idname" => "123456", "name" => "Invalid",
                                 "domains" => ['invalid.params.com'],
                                 "families" => [],
                                 "analytics" => false,
                                 "optimize_performance" => false}
    
    assert_nothing_raised() { Kit.new(valid_params) }
    assert_raise(ArgumentError) { Kit.new(invalid_datatype_params) }
    assert_raise(ArgumentError) { Kit.new(invalid_attributes_params) }

    # Check that Kit stores all attributes properly.
    kit = Kit.new(valid_params)
    valid_params.each do |k,v| 
      assert_equal(v, kit.send(k.to_sym))
    end
  end

  def test_fontfamily
    # Valid params for FontFamily
    valid_params = {"id" => "abc5def", "name" => "Valid Family Name",
                    "slug" => "valid_name",
                    "css_names" => ["Valid CSS Name!"], 
                    "css_stack" => "valid stack",
                    "subset" => "default", "variations" => ["n1", "n2"]}
    # Invalid datatypes in valid attributes.
    invalid_datatype_params = {"id" => 1234, "name" => 123, "slug" => {},
                               "css_names" => "invalid!", 
                               "css_stack" => ["invalid stack"],
                               "subset" => true, "variations" => "n1"}
    # Invalid attribute name in otherwise valid parameters.
    invalid_attributes_params = {"idname" => "abc5def", 
                                 "name" => "Valid Family Name",
                                 "slug" => "valid_name",
                                 "css_names" => ["Valid CSS Name!"], 
                                 "css_stack" => "valid stack",
                                 "subset" => "default", 
                                 "variations" => ["n1", "n2"]}

    assert_nothing_raised() { FontFamily.new(valid_params) }
    assert_raise(ArgumentError) { FontFamily.new(invalid_datatype_params) }
    assert_raise(ArgumentError) { FontFamily.new(invalid_attributes_params) }

    # CHeck that FontFamily stores all attributes properly.
    family = FontFamily.new(valid_params)
    valid_params.each do |k,v|
      assert_equal(v, family.send(k.to_sym))
    end
  end
end