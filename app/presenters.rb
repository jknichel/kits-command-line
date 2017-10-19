# A module of some simple presenter methods. If this project got any larger
# it would make sense to make larger Presenter classes for each object type
# that could present the objects in different formats. Because this is small
# in scope, I'm keeping it as a few individual methods for presenting to the
# command line instead of doing something more complex.
module Presenters
  INDENT = '  '

  # Because the /kits endpoint just returns a list of kit ids and links, I
  # deemed it simple enough to write a presenter that will take in the parsed
  # response and print the info to the console. Creating a new class to hold a
  # list of kits seems very much like overkill.
  def kit_list_to_console(parsed_json)
    kits = parsed_json['kits']

    puts "#{kits.count} kit(s) found:"
    kits.each_with_index do |kit_info, index|
      indented_puts "Kit ##{index + 1}:", 1
      indented_puts "ID: #{kit_info['id']}", 2
      indented_puts "Link: #{kit_info['link']}", 2
    end
  end

  # Takes in a Kit, and formats the data and prints it to the console.
  def kit_to_console(kit, indent_level=0)
    unless kit.is_a?(Kit)
      raise ArgumentError.new "Passed a different object into a Kit presenter"
    end

    [:id, :name, :domains].each do |attr| 
      indented_puts "#{attr.to_s}: #{kit.send(attr)}", indent_level 
    end

    indented_puts "families:", indent_level
    kit.families.each_with_index do |f, index|
      indented_puts "family ##{index + 1}:", indent_level + 1
      font_family_to_console(f, indent_level + 2)
    end

    indented_puts "optimize_performance: #{kit.optimize_performance}", indent_level
  end

  def font_family_to_console(family, indent_level=0)
    unless family.is_a?(FontFamily)
      raise ArgumentError.new "Passed a different object into a FontFamily presenter"
    end

    family.instance_variables.each do |attr|
      attr = attr.to_s.delete('@')
      indented_puts "#{attr}: #{family.send(attr.to_sym)}", indent_level
    end

    #indented_puts "ID: #{family.id}", indent_level
    #indented_puts "Name: #{family.name}", indent_level
    #indented_puts "slug: #{family.slug}", indent_level
    #indented_puts "CSS Names: #{family.css_names}", indent_level
    #indented_puts "CSS Stack: #{family.css_stack}", indent_level
    #indented_puts "Subset: #{family.subset}", indent_level
    #indented_puts "Variations: #{family.variations}", indent_level
  end

  def indented_puts(string, indent_level)
    puts "#{INDENT * indent_level}#{string}"
  end
end
